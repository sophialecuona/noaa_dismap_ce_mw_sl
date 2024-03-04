library(shiny)
library(ggplot2)
library(sf)
library(dplyr)
library(here)
library(tidyverse)

# Load data
load(here("shinyapp", "dsc.RData"))

ui <- fluidPage(
  titlePanel("California Marine Species Survey"),

  sidebarLayout(
    sidebarPanel(
      selectInput("species", "Select Species:",
                  choices = c("Dungeness Crab", "Squid", "Urchin"),
                  selected = "Dungeness Crab"),
      selectInput("year", "Select Year:",
                  choices = 2003:2022,
                  selected = 2003)
    ),

    mainPanel(
      plotOutput("distribution_plot")
    )
  )
)
