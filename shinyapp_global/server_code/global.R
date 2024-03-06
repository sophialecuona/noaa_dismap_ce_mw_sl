library(shiny)
library(tidyverse)
library(janitor)
library(dplyr)
library(wcfish)
library(broom)
library(ggplot2)
library(scales)
library(bslib)
library(leaflet)
library(here)
library(sf)

dung_survey <- read_csv(here("data","dungeness_survey_data.csv"))

dung_clean <- dung_survey %>%
  clean_names() %>%
  mutate(haul_id = dataset_west_coast_annual,
         stratum = x2,
         lat = x3,
         long = x4,
         depth = x5,
         year = x6,
         wtcpue = x7) %>%
  mutate(species = "dungeness") %>%
  select(species, haul_id, stratum, lat, long, depth, year, wtcpue) %>%
  drop_na()

squid_survey <- read_csv(here("data/squid_survey_data.csv"))

squid_clean <- squid_survey %>%
  clean_names() %>%
  mutate(haul_id = dataset_west_coast_annual,
         stratum = x2,
         lat = x3,
         long = x4,
         depth = x5,
         year = x6,
         wtcpue = x7) %>%
  mutate(species = "squid") %>%
  select(species, haul_id, stratum, lat, long, depth, year, wtcpue) %>%
  drop_na()

full_dung_squid <- full_join(
  dung_clean,
  squid_clean,
  by = NULL,
  suffix = c(".x", ".y"),
  keep = FALSE
)

chinook_survey <- read_csv(here("data/chinook_salmon_survey.csv"))

chinook_clean <- chinook_survey %>%
  clean_names() %>%
  mutate(haul_id = dataset_west_coast_triennial,
         stratum = x2,
         lat = x3,
         long = x4,
         depth = x5,
         year = x6,
         wtcpue = x7) %>%
  mutate(species = "chinook") %>%
  select(species, haul_id, stratum, lat, long, depth, year, wtcpue) %>%
  drop_na()

urchin_survey <- read_csv(here("data/northern_heart_urchin_survey.csv"))

urchin_clean <- urchin_survey %>%
  clean_names() %>%
  mutate(haul_id = dataset_west_coast_annual,
         stratum = x2,
         lat = x3,
         long = x4,
         depth = x5,
         year = x6,
         wtcpue = x7) %>%
  mutate(species = "urchin") %>%
  select(species, haul_id, stratum, lat, long, depth, year, wtcpue) %>%
  drop_na()

full_dung_squid_urch <- full_join(
  full_dung_squid,
  urchin_clean,
  by = NULL,
  suffix = c(".x", ".y"),
  keep = FALSE
) %>%
  filter(!wtcpue == 0)

full_dung_squid_chin <- full_join(
  full_dung_squid,
  chinook_clean,
  by = NULL,
  suffix = c(".x", ".y"),
  keep = FALSE
) %>%
  filter(!wtcpue == 0)

# Run if you don't already have devtools installed
# install.packages("devtools")

# Run once devtools is successfully installed
# devtools::install_github("cfree14/wcfish", force=T)
library(wcfish)

all <- pacfin_all1

eis <- all %>%
  select(year, comm_name, value_usd, landings_mt, landings_kg, landings_lb, price_usd_lb) %>%
  filter(comm_name %in% c("Chinook salmon", "Dungeness crab", "Market squid", "Red sea urchin"))

### Sophia

ca_counties_raw_sf <- read_sf(here("shinyapp_global","server_code", "data", "CA_Counties_TIGER2016.shp"))

ca_counties_sf <- ca_counties_raw_sf %>%
  janitor::clean_names() %>%
  mutate(land_km2 = aland / 1e6) %>%
  select(county = name, land_km2)

dung_survey1 <- read_csv(here("shinyapp_global","server_code", "data","dungeness_survey_data.csv"))

dung_clean1 <- dung_survey1 %>%
  clean_names() %>%
  mutate(haul_id = dataset_west_coast_annual,
         stratum = x2,
         lat = x3,
         long = x4,
         depth = x5,
         year = x6,
         wtcpue = x7) %>%
  mutate(species = "dungeness") %>%
  filter(lat < 42) %>%
  select(species, haul_id, stratum, lat, long, depth, year, wtcpue) %>%
  drop_na()

squid_survey1 <- read_csv(here("shinyapp_global","server_code", "data","squid_survey_data.csv"))

squid_clean1 <- squid_survey1 %>%
  clean_names() %>%
  mutate(haul_id = dataset_west_coast_annual,
         stratum = x2,
         lat = x3,
         long = x4,
         depth = x5,
         year = x6,
         wtcpue = x7) %>%
  mutate(species = "squid") %>%
  filter(lat < 42) %>%
  select(species, haul_id, stratum, lat, long, depth, year, wtcpue) %>%
  drop_na()

full_dung_squid1 <- full_join(
  dung_clean1,
  squid_clean1,
  by = NULL,
  suffix = c(".x", ".y"),
  keep = FALSE
)

urchin_survey1 <- read_csv(here("shinyapp_global","server_code", "data","northern_heart_urchin_survey.csv"))

urchin_clean1 <- urchin_survey1 %>%
  clean_names() %>%
  mutate(haul_id = dataset_west_coast_annual,
         stratum = x2,
         lat = x3,
         long = x4,
         depth = x5,
         year = x6,
         wtcpue = x7) %>%
  mutate(species = "urchin") %>%
  filter(lat < 42) %>%
  select(species, haul_id, stratum, lat, long, depth, year, wtcpue) %>%
  drop_na()

full_dung_squid_urch1 <- full_join(
  full_dung_squid1,
  urchin_clean1,
  by = NULL,
  suffix = c(".x", ".y"),
  keep = FALSE
) %>%
  filter(!wtcpue == 0)%>%
  filter(lat < 42)

message("Fixing CRS")
sf_dsc <- st_as_sf(full_dung_squid_urch1, coords = c("long", "lat"), crs = 4326)

dsc <- st_transform(sf_dsc, st_crs(ca_counties_raw_sf))

# Plotting catch data by year for each species

## Dungeness

# using loop and lapply:
# Filter the "dungeness" species
dung <- dsc %>%
  filter(species == "dungeness")

# make a list of plots for each year
year_plots <- lapply(2003:2022, function(years) {
  dung_year <- dung %>%
    filter(years == as.character(year))

  dung_map_year <- ggplot() +
    geom_sf(data = ca_counties_sf,
            color = "darkgrey",
            fill = "grey",
            size = 1) +
    geom_sf(data = dung_year,
            aes(shape = "square"),
            color = "orange",
            alpha = 0.7,
            size = 3) +
    scale_shape_manual(values = 15) +
    labs(title = paste("Dungeness Crab Distribution -", years)) +
    theme_void()

  print(dung_map_year)
})

# save as PNG files
# lapply(1:length(year_plots), function(i) {
#   ggsave(filename = paste0("dung_map_", 2003 + i - 1, ".png"), plot = year_plots[[i]], width = 10, height = 8)
# })


## Squid

squid <- dsc %>%
  filter(species == "squid")

#by year

# make a list of plots for each year
squid_year_plots <- lapply(2003:2022, function(years) {
  squid_year <- squid %>%
    filter(years == as.character(year))

  squid_map_year <- ggplot() +
    geom_sf(data = ca_counties_sf,
            color = "darkgrey",
            fill = "grey",
            size = 1) +
    geom_sf(data = squid_year,
            aes(shape = "square"),
            color = "bisque4",
            alpha = 0.7,
            size = 3) +
    scale_shape_manual(values = 15) +
    labs(title = paste("Market Squid Distribution -", years)) +
    theme_void()

  print(squid_map_year)
})

# save as PNG files
# lapply(1:length(squid_year_plots), function(i) {
#   ggsave(filename = paste0("squid_map_", 2003 + i - 1, ".png"), plot = squid_year_plots[[i]], width = 10, height = 8)
# })


## Urchin

urchin <- dsc %>%
  filter(species == "urchin")

#by year

# make a list of plots for each year
urchin_year_plots <- lapply(2003:2022, function(years) {
  urchin_year <- urchin %>%
    filter(years == as.character(year))

  urchin_map_year <- ggplot() +
    geom_sf(data = ca_counties_sf,
            color = "darkgrey",
            fill = "grey",
            size = 1) +
    geom_sf(data = urchin_year,
            aes(shape = "square"),
            color = "darkmagenta",
            alpha = 0.7,
            size = 3) +
    scale_shape_manual(values = 15) +
    labs(title = paste("Northern Heart Urchin Distribution -", years)) +
    theme_void()

  print(urchin_map_year)
})

# save as PNG files
# lapply(1:length(urchin_year_plots), function(i) {
#   ggsave(filename = paste0("urchin_map_", 2003 + i - 1, ".png"), plot = urchin_year_plots[[i]], width = 10, height = 8)
# })


