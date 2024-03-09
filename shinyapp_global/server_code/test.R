library(shiny)
library(ggplot2)
library(dplyr)

# Assuming 'eis', 'temp_df', and other necessary data frames are loaded and processed

ui <- fluidPage(
  tabItem(tabName = "revenue",
          fluidRow(
            box(width = 4, height = 500,
                title = tags$strong("Select Species:"),
                checkboxGroupInput(inputId = "species_select_input",
                                   label = "Select Species:",
                                   choices = c("dungeness", "squid", "urchin"),
                                   selected = "dungeness")
            ), # END input box

            box(width = 8, height = 500,
                title = tags$strong("Revenue Plots"),
                plotOutput(outputId = "revenue_plot")
            ) # END plot box
          ) # END fluidRow
  ) # END revenue tabItem
) # END fluidPage

server <- function(input, output, session) {

  # Reactive expression for filtering data based on user input
  filtered_data <- reactive({
    # Filter data based on selected species
    selected_species <- input$species_select_input
    filtered <- eis %>%
      filter(comm_name %in% selected_species) %>%
      full_join(temp_df, by = 'year') %>%
      drop_na()
    return(filtered)
  })

  # Render revenue plot based on filtered data
  output$revenue_plot <- renderPlot({
    filtered <- filtered_data()
    if (!is_empty(filtered)) {
      revenue_output <- lm(value_usd ~ average_temp, data = filtered)
      ggplot(filtered, aes(x = average_temp, y = value_usd)) +
        geom_point() +
        labs(x = "Sea Surface Temperature (C)", y = "Revenue in Millions (USD)") +
        geom_abline(intercept = coef(revenue_output)[1],
                    slope = coef(revenue_output)[2]) +
        theme_bw() +
        scale_y_continuous(labels = scales::label_number(scale = 1e-6))
    } else {
      ggplot() + geom_blank() +
        labs(title = "No data available for selected species")
    }
  })
}

shinyApp(ui = ui, server = server)

