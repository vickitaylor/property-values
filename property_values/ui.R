



# Define UI for application t
ui <- page_fluid(
  
  theme = bs_theme(version = 5, bootswatch = 'morph'),
  
  # Application title
  titlePanel('Tennessee Property Valuations'),
  
  # Sidebar with a date selection input
  # sidebarLayout(
    dateRangeInput(
      inputId = 'input_date',
      label = 'Select Date Range',
      start = min_date,
      end = max_date,
      format = 'mm/dd/yyyy'
    
    )
  # ),
  # mainPanel(
    # plotOutput("distPlot")
  # )
)
  
  
  # sidebarPanel(
  #     sliderInput("bins",
  #                 "Number of bins:",
  #                 min = 1,
  #                 max = 50,
  #                 value = 30)
  
  # Show a plot of the generated distribution