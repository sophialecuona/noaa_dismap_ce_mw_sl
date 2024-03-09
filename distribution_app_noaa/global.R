# LOAD LIBRARIES ----
library(shiny)
library(shinydashboard)
library(tidyverse)
library(leaflet)
library(shinycssloaders)
library(sf)
library(markdown)
library(fresh)
library(shinycssloaders)
library(here)
library(broom)
library(janitor)
library(cowplot)
library(patchwork)
library(dplyr)

#devtools::install_github("cfree14/wcfish", force=T)
library(wcfish)


# READ IN DATA ---- sophia
ca_counties_sf <- read_csv("data/ca_counties_sf.csv")
dsc <- read_csv("data/dsc.csv")
full_dung_squid_urch1 <- read_csv("data/full_dsu.csv")

# READ IN DATA ---- caroline
dismap_all_df <- read_csv("data/full_dung_squid_chin.csv")
avg_temp_df <- read_csv("data/average_temp.csv")

## Filtering not to include Chinook
merged_dis_temp <- merge(avg_temp_df, dismap_all_df, by = "year")
merge_nochinook <- merged_dis_temp[merged_dis_temp$species != "chinook", ]

# READ IN DATA ---- maddie
eis <- read_csv("data/eis.csv")
temp_df <- read_csv("data/average_temp.csv")
