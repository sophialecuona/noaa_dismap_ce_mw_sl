# https://github.com/sophialecuona/noaa_dismap_ce_mw_sl.git
# Caroline Edmonds, Maddie Whitman, Sophia Lecuona

library(shiny)
library(bslib)
library(tidyverse)
library(shinydashboard)
library(tidyverse)
library(palmerpenguins)

### Create the user interface:
ui <- fluidPage()

### Create the server function:
server <- function(input, output) {}

### Combine them into an app:
shinyApp(ui = ui, server = server)

  ### Create the user interface:
  ui <- fluidPage(
    titlePanel("I am adding a title!"),
    sidebarLayout(
      sidebarPanel("put my widgets here"),
      mainPanel("put my graph here")
    ) ### end sidebarLayout#
  ) ### end fluidPage


    sidebarLayout(
      sidebarPanel("put my widgets here",

                   radioButtons(
                     inputId = "penguin_species",
                     label = "Choose penguin species",
                     choices = c("Adelie","Gentoo","Cool Chinstrap Penguins!" = "Chinstrap")
                   )

      ), ### end sidebarLayout

      mainPanel("put my graph here")

    ) ### end sidebarLayout

