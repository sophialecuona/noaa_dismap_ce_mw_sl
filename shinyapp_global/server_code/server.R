# Define server logic
server <- function(input, output, session) {
  filtered_data <- reactive({
    eis %>%
      filter(comm_name == input$species)
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
}

# Run the application
shinyApp(ui = ui, server = server)

