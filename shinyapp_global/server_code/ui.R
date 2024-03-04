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

    tabPanel(
      title = 'Habitat Range',
      p("Tab 1: Species Range",
        br(),
        "- Species",
        br(),
        "- Convert lat/long into shapefile",
        br(),
        "- Year - indexed by colors",
        br(),
        "- Picture of species",
        br(),
        "- Widgets:Map, Slider, Animated???? lol",
        br(),
        "- Need to get historic data (90’s year)",
        br(),
        "What questions do we want to ask/answer about our data?;",
        br(),
        "How are the most economically important stocks moving in CA?",
        br(),
        "How is the CPUE changing overtime for these stocks?",
        br(),
        "Could correlate with policy change or new technology?",
        br(),
        "Water temp and lat and long increasing over time?",
        br(),
        "Would have to find and pull in another data set.",
        br(),
        "Are the surveys missing any key areas??"
      ),
      # Embed an interactive map using an iframe
      tags$iframe(src = "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3312.170979609962!2d-118.48477998481262!3d34.01945408061439!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x80c2c75ddc27da13%3A0xe22fdf787b21f55e!2sCalifornia%2C%20USA!5e0!3m2!1sen!2sca!4v1647273999725!5m2!1sen!2sca",
                  height = "600px", width = "800px", frameborder = "0")
    ), ### end tab 2

    tabPanel(
      title = 'Distribution movement (years ____ - ____)',
      p("Tab 2: Movement over the years.
        DisMAP (mimic).
        See how fish move with lat, long, and depth.
        Show 1 or 2 graphs.
        Widgets.
        Sliders or dropdown.
        Map.
        Static map(s) (placeholder).
      "),
      sidebarPanel(
        sliderInput("Date Range",
                    "Select a value:",  # Slider label
                    min = 2003,            # Minimum value
                    max = 2022,          # Maximum value
                    value = 2003)         # Initial value
      ),
      sidebarLayout(
        sidebarPanel(
          h3('Select Species'),
          radioButtons(
            inputId = 'spp_button',
            label = 'Species',
            choices = c( 'Squid', 'Dungeness Crab', 'Chinook Salmon')
          )
        ),
        mainPanel(
          h2('Here is a main panel')
        )
      ) ### end sidebarLayout
    ), ### end tab 3

    tabPanel(
      title = 'Distribution and Temperature',
      p("Tab 3: CPUE and TEMP!
        Need to get sea surface temp or CTD profile data.
        Widgets: Map,
        Sliders.
      "),
      sidebarPanel(
        selectInput("species",           # Input ID
                    "Select Species:",  # Input label
                    choices = c('Species A', 'Species B', 'Species C'),  # Dropdown choices
                    selected = "Species A")  # Initial selection
      ),
      # Additional widgets can be added here
    ), ### end tab 4

    tabPanel(
      title = 'Data Citation',
      p("NOAA Fisheries. 2022. DisMAP data records. Retrieved from apps-st.fisheries.noaa.gov/dismap/DisMAP.html. Accessed 1/20/2024.",
      br(),
      br(),
        "Free, C. (2024). wcfish: R Package for accessing fisheries data. GitHub. https://github.com/cfree14/wcfish. Accessed 2/29/2024."),
    ) ### end tab 5

  ) ### end of tabsetpanel
)
