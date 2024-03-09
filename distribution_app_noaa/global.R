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


# READ IN DATA ---- sophia
ca_counties_sf <- read_csv("data/ca_counties_sf.csv")
dsc <- read_csv("data/dsc.csv")
full_dung_squid_urch1 <- read_csv("data/full_dsu.csv")

# READ IN DATA ---- caroline
dismap_all_df <- read_csv("data/full_dung_squid_chin.csv")
avg_temp_df <- read_csv("data/average_temp.csv")

# READ IN DATA ---- maddie
