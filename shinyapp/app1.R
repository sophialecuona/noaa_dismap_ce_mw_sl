library(magick)

# Create the www directory if it doesn't exist
if (!dir.exists("www")) {
  dir.create("www")
}

# List of PNG files for Dungeness
dung_files <- list.files("www", pattern = "dung_map_", full.names = TRUE)

# Check if there are any files to create GIF
if (length(dung_files) > 0) {
  # Create GIF for Dungeness
  dung_gif <- image_animate(image_read(dung_files), fps = 1, loop = 0)

  # Save Dungeness GIF
  image_write(dung_gif, path = "www/dung_survey.gif")
} else {
  # If no files found, create an empty GIF
  image_blank(width = 100, height = 100) %>%
    image_write("www/dung_survey.gif")
}

# List of PNG files for Urchin
urchin_files <- list.files("www", pattern = "urchin_map_", full.names = TRUE)

if (length(urchin_files) > 0) {
  # Create GIF for Urchin
  urchin_gif <- image_animate(image_read(urchin_files), fps = 1, loop = 0)

  # Save Urchin GIF
  image_write(urchin_gif, path = "www/urchin_survey.gif")
} else {
  # If no files found, create an empty GIF
  image_blank(width = 100, height = 100) %>%
    image_write("www/urchin_survey.gif")
}

# List of PNG files for Squid
squid_files <- list.files("www", pattern = "squid_map_", full.names = TRUE)

if (length(squid_files) > 0) {
  # Create GIF for Squid
  squid_gif <- image_animate(image_read(squid_files), fps = 1, loop = 0)

  # Save Squid GIF
  image_write(squid_gif, path = "www/squid_survey.gif")
} else
  # If no files found, create an empty GIF

  library(shiny)

# Define the server function
server <- function(input, output, session) {

  output$dung_gif <- renderImage({
    list(src = "dung_survey.gif",
         contentType = "image/gif")
  }, deleteFile = FALSE)

  output$squid_gif <- renderImage({
    list(src = "squid_survey.gif",
         contentType = "image/gif")
  }, deleteFile = FALSE)

  output$urchin_gif <- renderImage({
    list(src = "urchin_survey.gif",
         contentType = "image/gif")
  }, deleteFile = FALSE)

}

# Define the UI
ui <- fluidPage(
  titlePanel("Survey Animations"),

  fluidRow(
    column(6,
           h2("Dungeness Crab"),
           imageOutput("dung_gif")
    ),
  ),

  fluidRow(
    column(6,
           h2("Market Squid"),
           imageOutput("squid_gif")
    ),
    column(6,
           h2("Northern Heart Urchin"),
           imageOutput("urchin_gif")
    )
  )
)

# Run the Shiny app
shinyApp(ui = ui, server = server)
