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

# READ IN DATA ----
ca_counties_sf <- read_csv("data/ca_counties_sf.csv")
dsc <- read_csv("data/dsc.csv")
full_dung_squid_urch1 <- read_csv("data/full_dsu.csv")
