library(shiny)
library(tidyverse)
library(janitor)
library(dplyr)
library(wcfish)
library(broom)
library(ggplot2)
library(scales)
library(bslib)
library(leaflet)

# Load data
all <- pacfin_all1
eis <- all %>%
  select(year, comm_name, value_usd, landings_mt, landings_kg, landings_lb, price_usd_lb)

# Load data
load(here("shinyapp", "dsc.RData"))

# Define UI
ui <- fluidPage(
  theme = bs_theme(bootswatch = 'solar'),
  titlePanel("California Economically Important Species Through Space and Time"),
  tabsetPanel(
    tabPanel(
      title = 'Species Revenue Analysis',
      sidebarLayout(
        sidebarPanel(
          selectInput("species", "Select Species:",
                      choices = unique(eis$comm_name),
                      selected = "Market squid"),
          actionButton("update", "Update Analysis")
        ),
        mainPanel(
          tabsetPanel(
            tabPanel("Coefficients", tableOutput("coefficients_table")),
            tabPanel("Plot", plotOutput("species_plot"))
          )
        )
      )
    ), ### end tab 1

    tabPanel("California Marine Species Survey"),

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
      ) ### end sidebarLayout
    ), ### end tab 3

    tabPanel(
      title = 'Data Citation',
      p("NOAA Fisheries. 2022. DisMAP data records. Retrieved from apps-st.fisheries.noaa.gov/dismap/DisMAP.html. Accessed 1/20/2024.",
        br(),
        br(),
        "Free, C. (2024). wcfish: R Package for accessing fisheries data. GitHub. https://github.com/cfree14/wcfish. Accessed 2/29/2024."),
    ) ### end tab 5

  ) ### end of tabsetpanel


# Define server logic
server <- function(input, output, session) {
  filtered_data <- reactive({
    eis %>%
      filter(comm_name == input$species)

  filtered_data <- reactive({
    species_data <- switch(input$species,
                             "Dungeness Crab" = dsc %>% filter(species == "dungeness"),
                             "Squid" = dsc %>% filter(species == "squid"),
                             "Urchin" = dsc %>% filter(species == "urchin"))

      species_data %>%
        filter(year == input$year)
  })

  output$coefficients_table <- renderTable({
    # Perform linear regression
    squid_output <- lm(value_usd ~ year, data = filtered_data())
    # Get coefficients and tidy them
    coefficients <- tidy(squid_output)
    # Return coefficients as a table
    coefficients
  })

  output$species_plot <- renderPlot({
    # Perform linear regression
    squid_output <- lm(value_usd ~ year, data = filtered_data())
    # Create ggplot
    ggplot(filtered_data(), aes(x = year, y = value_usd)) +
      geom_point() +
      labs(x = "Year", y = "Revenue in Millions (USD)") +
      geom_abline(
        intercept = coef(squid_output)[1],
        slope = coef(squid_output)[2]
      ) +
      theme_bw() +
      scale_y_continuous(labels = scales::label_number(scale = 1e-6))
  })

  observeEvent(input$update, {
    updateTabsetPanel(session, "tabset", selected = "Plot")
  })

  output$distribution_plot <- renderPlot({
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

# Run the application
shinyApp(ui = ui, server = server)

