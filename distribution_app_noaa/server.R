server <- function(input, output) {

  # survey data ----
  survey_df <- reactive ({

    full_dung_squid_urch1 |>
      filter(depth >= input$depth_slider_input[1] & depth <= input$depth_slider_input[2])  |>
      filter(year >= input$year_slider_input[1] & year <= input$year_slider_input[2]) |>
      filter(species %in% input$species_select_input[1]) |>
    merge_nochinook |>
      filter(year >= input$year_slider_input[1] & year <= input$year_slider_input[2])
  })



  # build leaflet map ----
  output$coast_map_output <- renderLeaflet({

    leaflet() |>

      # add tiles
      addProviderTiles(providers$Esri.WorldImagery) |>

      # set view over AK
      setView(lng = -119.000000, lat = 38.000000, zoom = 5) |>

      # add mini map
      addMiniMap(toggleDisplay = TRUE, minimized = TRUE) |>

      # add markers
      addMarkers(data =  survey_df(),
                 lng = survey_df()$long, lat = survey_df()$lat,
                 popup = paste("Species:", survey_df()$species, "<br>",
                               "Depth:", survey_df()$depth, "*meters* (below SL)", "<br>",
                               "Year:", survey_df()$year, "<br>",
                               "Catch per unit effort:", survey_df()$wtcpue, "kg per ha")
      )
  })

}
