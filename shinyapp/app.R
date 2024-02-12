library(shiny)
library(tidyverse)
library(palmerpenguins)

### Create the user interface:
ui <- fluidPage()

  ### Create the user interface:
  ui <- fluidPage(
    titlePanel("I am adding a title!"),
    sidebarLayout(
      sidebarPanel("put my widgets here"),
      mainPanel("put my graph here")
    ) ### end sidebarLayout#
  ) ### end fluidPage

### Create the server function:
server <- function(input, output) {}

### Combine them into an app:
shinyApp(ui = ui, server = server)
