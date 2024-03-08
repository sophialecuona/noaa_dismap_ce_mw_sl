library(tidyverse)
library(here)
library(broom)
library(janitor)
library(ggplot2)
library(gganimate)
library(magick)
library(gifski)
library(cowplot)
library(patchwork)
library(dplyr)

# Spatial data packages
library(sf)
library(tmap)
library(spatstat)
library(terra)


# SOPHIA Plots:

# CA Counties processing
ca_counties_raw_sf <- read_sf(here("data", "ca_counties2", "CA_Counties_TIGER2016.shp"))

ca_counties_raw_sf %>% st_crs()
ca_counties_raw_sf %>% terra::crs()

ca_counties_sf <- ca_counties_raw_sf %>%
  janitor::clean_names() %>%
  mutate(land_km2 = aland / 1e6) %>%
  select(county = name, land_km2)

## save processed data to your app's data directory ----
write_csv(x = ca_counties_sf, file = here::here("distribution_app_noaa", "data", "ca_counties_sf.shp"))

# DSC Survey data processing
full_dung_squid_urch1 <- read_csv(here("distribution_app_noaa", "data", "full_dsu.csv"))

sf_dsc <- st_as_sf(full_dung_squid_urch1, coords = c("long", "lat"), crs = 4326)

dsc <- st_transform(sf_dsc, st_crs(ca_counties_sf))

## save processed data to your app's data directory ----
write_csv(x = dsc, file = here::here("distribution_app_noaa", "data", "dsc.csv"))


# Save by species

## Dungeness
dung <- dsc %>%
  filter(species == "dungeness")

## Squid
squid <- dsc %>%
  filter(species == "squid")

## Urchin
urchin <- dsc %>%
  filter(species == "urchin")

## Dungeness animation
dung_plot <- ggplot() +
  geom_sf(data = ca_counties_sf,
          color = "darkgrey",
          fill = "grey",
          size = 1) +
  geom_sf(data = dung,
          aes(shape = "square", color = wtcpue),
          alpha = 0.7,
          size = 3) +
  labs(title = "Dungeness Distribution",
       color = "Catch per unit effort") +
  guides(shape = "none") +
  theme_void()
dung_plot

dung_anim <- dung_plot +
  transition_time(year) +
  enter_appear()

anim_save("distribution_app_noaa/www/dung_distribution.gif", animation = dung_anim, nframes = 19)


## Squid animate plot
squid_plot <- ggplot() +
  geom_sf(data = ca_counties_sf,
          color = "darkgrey",
          fill = "grey",
          size = 1) +
  geom_sf(data = squid,
          aes(shape = "square", color = wtcpue),
          alpha = 0.7,
          size = 3) +
  labs(title = "Market Squid Distribution",
       color = "Catch per unit effort") +
  guides(shape = "none") +
  theme_void()
squid_plot

squid_anim <- squid_plot +
  geom_text(aes(label = year),
            data = squid,
            x = max(ca_counties_sf$geometry$x) - 5,
            y = min(ca_counties_sf$geometry$y) + 0.1,
            size = 5,
            color = "black",
            show.legend = FALSE,
            hjust = 1, vjust = 0) +
  transition_time(year) +
  enter_appear()

anim_save("distribution_app_noaa/www/squid_distribution.gif", animation = squid_anim, nframes = 19)

## Urchin animation
urchin_plot <- ggplot() +
  geom_sf(data = ca_counties_sf,
          color = "darkgrey",
          fill = "grey",
          size = 1) +
  geom_sf(data = urchin,
          aes(shape = "square", color = wtcpue),
          alpha = 0.7,
          size = 3) +
  labs(title = "Urchin Distribution",
       color = "Catch per unit effort") +
  guides(shape = "none") +
  theme_void()
urchin_plot

urchin_anim <- urchin_plot +
  transition_time(year) +
  enter_appear()

anim_save("distribution_app_noaa/www/urchin_distribution.gif", animation = urchin_anim, nframes = 19)

# MADDIE Plots:


# CAROLINE Plots:
