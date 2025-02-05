# Define UI for application t
ui <- page_fluid(
  theme = bs_theme(version = 5, bootswatch = 'morph'),
  
  # Application title
  titlePanel('Tennessee Property Valuations'),
  
  # Sidebar with a date selection input
  sidebarLayout(
    sidebarPanel(
      dateRangeInput(
        inputId = 'date',
        label = 'Select Date Range',
        start = min_date,
        end = max_date,
        format = 'mm/dd/yyyy'
      ), 
      selectInput(
        inputId = 'region', 
        label = 'Select Region',
        choices = c( 'All', values |> distinct(parent_metro_region) |> pull(parent_metro_region) |> sort()),
        selected = 1
      )
    ),
    
    mainPanel(
      plotlyOutput(outputId = 'value_line')
    )
  )
)

# sidebarPanel(
#     sliderInput("bins",
#                 "Number of bins:",
#                 min = 1,
#                 max = 50,
#                 value = 30)

# Show a plot of the generated distribution
