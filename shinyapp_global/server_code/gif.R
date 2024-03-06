library(gapminder)
library(ggplot2)
library(shiny)
library(gganimate)
library(sf)
theme_set(theme_bw())

ui <- basicPage(
  imageOutput("plot1")
)

server <- function(input, output) {
  output$plot1 <- renderImage({
    # A temp file to save the output.
    # This file will be removed later by renderImage
    outfile <- tempfile(fileext='.gif')

    # now make the animation
    p <- lapply(2003:2022, function(year) {
      dung_year <- dung %>%
        filter(year == as.character(year))

      dung_map_year <- ggplot() +
        geom_sf(data = ca_counties_sf,
                color = "darkgrey",
                fill = "grey",
                size = 1) +
        geom_sf(data = dung_year,
                aes(shape = "square", color = wtcpue),
                alpha = 0.7,
                size = 2) +
        scale_color_continuous() +
        scale_shape_manual(values = 15) +
        labs(title = paste("Dungeness Crab Distribution -", year))

      return(dung_map_year)
    })

    p <- ggplot() +
      transition_manual(frame = year) +
      exit_fade() +
      labs(title = 'Dungeness Crab Distribution - {frame_time}')

    p <- gganimate::animate(p, nframes = length(p), renderer = gifski_renderer())
    anim_save("outfile.gif", p)

    # Return a list containing the filename
    list(src = "outfile.gif",
         contentType = 'image/gif'
         # width = 400,
         # height = 300,
         # alt = "This is alternate text"
    )
  }, deleteFile = TRUE)
}

shinyApp(ui, server)

