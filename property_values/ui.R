# Define UI for application
ui <- page_fluid(
  theme = bs_theme(version = 5, bootswatch = "morph"),

  # Application title
  titlePanel("Tennessee Property Valuations"),

  # Sidebar with a date selection input
  navset_pill(
    nav_panel(
      "Valuation Over Time",
      sidebarLayout(
        sidebarPanel(
          width = 3,
          dateRangeInput(
            inputId = "date",
            label = "Select Date Range",
            start = min_date,
            end = max_date,
            format = "mm/dd/yyyy"
          ),
          # Select region dropdown
          selectInput(
            inputId = "region",
            label = "Select Region",
            choices = c("All", values |> distinct(parent_metro_region) |> pull(parent_metro_region) |> sort()),
            selected = 1
          ),
          # aggregation type, only appears on the sales by month tab
          conditionalPanel(
            condition = "input.tabs == 'Sales by Month'",
            radioButtons(
              inputId = "agg_type",
              label = "Select Aggregation Type",
              choices = c(
                "Total Sales" = "total_sales",
                "Average Sales per Year" = "average_sales"
              ),
              selected = "total_sales"
            )
          )
        ),
        mainPanel(
          width = 9,
          tabsetPanel(
            id = "tabs",
            tabPanel(
              "Property Valuations",
              br(),
              conditionalPanel(
                condition = "input.tabs" == "Property Valuations",
                fluidRow(
                  column(
                    4,
                    valueBoxOutput(
                      "card_val",
                      width = 12
                    )
                  ),
                  column(
                    4,
                    valueBoxOutput(
                      "card_sale",
                      width = 12
                    )
                  ), 
                  
                  
                  column(
                    4,
                    valueBoxOutput(
                      "card_cor",
                      width = 12
                    )
                  )
                )
              ),
                  
              plotlyOutput(
                outputId = "value_line",
                width = "100%",
                height = "350px"
              ),
              br(),
              plotlyOutput(
                outputId = "sales_line",
                width = "100%",
                height = "350px"
              )
            ),
            br(),
            tabPanel(
              "Sales by Month",
              plotlyOutput(
                outputId = "month_bar",
                width = "100%",
                height = "600px"
              )
            )
          )
        ),
      )
    ),
    nav_panel("Other",)
  )
)
