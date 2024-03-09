server <- function(input, output) {

  # survey data ----
  survey_df <- reactive ({

    full_dung_squid_urch1 |>
      filter(depth >= input$depth_slider_input[1] & depth <= input$depth_slider_input[2])  |>
      filter(year >= input$year_slider_input[1] & year <= input$year_slider_input[2]) |>
      filter(species %in% input$species_select_input[1]) |>
    merge_nochinook |>
      filter(depth >= input$depth_input[1] & depth <= input$depth_input[2])  |>
      filter(year >= input$year_input[1] & year <= input$year_input[2]) |>
      filter(species %in% input$species_input[1])
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

  # build cpue plots ----
  output$cpue_temp <- renderPlot({

    ggplot(merge_nochinook, aes(x = year)) +
      geom_point(aes(y = wtcpue, color = species), alpha = 0.5, size = 1.5) +  # Swap y = average_temp with y = wtcpue
      geom_line(aes(y = average_temp), color = "red", size = 1.5) + # Swap y = wtcpue with y = average_temp
      scale_x_discrete(labels = c("Dungeness", "Squid")) +
      facet_wrap(~ species, scales = "free_y", ncol = 1, labeller = labeller(species = c("squid" = "Squid", "dungeness" = "Dungeness Crab"))) +
      labs(title = "Squid and Dungeness Crab CPUE vs Temperature",
           x = "Year",
           y = "Weighted CPUE") +
      scale_color_manual(
        values = c("#603B38", "#CF9555"),
        breaks = c("squid", "dungeness"),
        labels = c("Squid", "Dungeness Crab")
      ) +
      guides(color = guide_legend(title = "Species")) +
      theme(strip.background = element_blank(), strip.placement = "outside")+
      scale_y_continuous(
        sec.axis = sec_axis(~., name = "Temperature (°C)", breaks = seq(0, 30, by = 5)),
        name = "Weighted CPUE",
        limits = c(0, max(merge_nochinook$average_temp) * 3)  # Adjust the limits as needed
      )
  })

}
