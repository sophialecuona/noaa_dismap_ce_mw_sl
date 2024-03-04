library(shiny)
library(ggplot2)
library(sf)
library(dplyr)
library(tidyverse)

# Load data
load(here("shinyapp", "dsc.RData"))

server <- function(input, output, session) {

  filtered_data <- reactive({
    species_data <- switch(input$species,
                           "Dungeness Crab" = dsc %>% filter(species == "dungeness"),
                           "Squid" = dsc %>% filter(species == "squid"),
                           "Urchin" = dsc %>% filter(species == "urchin"))

    species_data %>%
      filter(year == input$year)
  })

  output$species_plot <- renderPlot({
    ggplot() +
      geom_sf(data = ca_counties_sf,
              color = "darkgrey",
              fill = "grey",
              size = 1) +
      geom_sf(data = filtered_data(),
              aes(shape = "square"),
              color = switch(input$species,
                             "Dungeness Crab" = "orange",
                             "Squid" = "bisque4",
                             "Urchin" = "darkmagenta"),
              alpha = 0.7,
              size = 3) +
      scale_shape_manual(values = 15) +
      labs(title = paste(input$species, "Distribution -", input$year)) +
      theme_void()
  })

}

