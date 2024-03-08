library(tidyverse)
library(here)
library(broom)
library(janitor)
library(ggplot2)

# Spatial data packages
library(sf)
library(tmap)
library(spatstat)
library(terra) 

# CA Counties processing
ca_counties_raw_sf <- read_sf(here("distribution_app", "data", "ca_counties3", "CA_Counties_TIGER2016.shp"))

ca_counties_raw_sf %>% st_crs()
ca_counties_raw_sf %>% terra::crs()

ca_counties_sf <- ca_counties_raw_sf %>% 
  janitor::clean_names() %>%
  mutate(land_km2 = aland / 1e6) %>%
  select(county = name, land_km2)

## save processed data to your app's data directory ----
write_csv(x = ca_counties_sf, file = here::here("distribution_app", "data", "ca_counties_sf.shp"))

# DSC Survey data processing
full_dung_squid_urch1 <- read_csv(here("distribution_app", "data", "full_dsu.csv"))

sf_dsc <- st_as_sf(full_dung_squid_urch1, coords = c("long", "lat"), crs = 4326)

dsc <- st_transform(sf_dsc, st_crs(ca_counties_sf))

## save processed data to your app's data directory ----
write_csv(x = dsc, file = here::here("distribution_app", "data", "dsc.shp"))
