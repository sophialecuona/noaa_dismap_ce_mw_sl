library(shiny)
library(bslib)
library(tidyverse)

ui <- fluidPage(
  theme = bs_theme(bootswatch = 'cerulean'),

  titlePanel ('California Economically Important Species Through Space and Time'),
  tabsetPanel(

    tabPanel(
      title = 'Tab 1',
    ), ### end tab 1

    tabPanel(
      title = 'Tab 2',
      sidebarLayout(
        sidebarPanel(
          h3('Select Species'),
          radioButtons(
            inputId = 'spp_button',
            label = 'Species',
            choices = c( 'Squid', 'Dungeness Crab', 'Skipjack Tuna')
          )
        ),
        mainPanel(
          h2('Here is a main panel')
        )
      ) ### end sidebarLayout
    ), ### end tab 2

    tabPanel(
      title = 'Tab 3',
    ), ### end tab 3

    tabPanel(
      title = 'Tab 4'
    ) ### end tab 4

  ) ### end of tabsetpanel
)


server <- function(input, output) {
  #### put sever functions here

}

### combine into app:
shinyApp(ui = ui, server = server)
