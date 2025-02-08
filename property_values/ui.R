# Define UI for application 
ui <- page_fluid(
  theme = bs_theme(version = 5, bootswatch = 'morph'),
  
  # Application title
  titlePanel('Tennessee Property Valuations'),
  
  # Sidebar with a date selection input
  navset_pill(
    nav_panel('Valuation Over Time', 
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
                  ), 
                  radioButtons(
                    inputId = 'agg_type', 
                    label = 'Select Aggregation Type', 
                    choices = c('Total Sales' = 'total_sales', 
                                'Average Sales per Year' = 'average_sales'),
                    selected = 'total_sales'
                  )
                ),
                mainPanel(
                  tabsetPanel(
                    tabPanel('Property Valuations',
                             plotlyOutput(outputId = 'value_line'), 
                             plotlyOutput(outputId = 'sales_line')
                    ), 
                    tabPanel('Sales by Month',
                             plotlyOutput(outputId = 'month_bar')
                    )
                  ), 
                )
              )
    ),
    nav_panel('Other', 
              
    )
    
    
  )
)






