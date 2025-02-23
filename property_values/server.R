




# Define server logic
function(input, output, session) {
  # dates are only the last day of the month but allowing any day for selection, so need to change the date to find in the table
  min_date <- reactive({
    min_date <- ceiling_date(as.Date(input$date[1]), 'month') - days(1)
  })
  
  max_date <- reactive({
    max_date <- ceiling_date(as.Date(input$date[2]), 'month') - days(1)
  })
  
  region_data <- reactive({
    region <- values
    
    if (input$region != 'All') {
      region <- region |>
        filter(parent_metro_region == input$region) |>
        mutate(
          month_int = month(period_end),
          month_name = month(period_end, label = TRUE, abbr = TRUE),
          year = year(period_end)
        ) |>
        group_by(period_end, month_int, month_name, year) |>
        summarize(
          estimated_value = mean(estimated_value, na.rm = TRUE),
          homes_sold = sum(homes_sold, na.rm = TRUE),
          total_sales = sum(homes_sold, na.rm = TRUE),
          average_sales = mean(homes_sold, na.rm = TRUE),
          avg_sales_price = mean(median_sale_price, na.rm = TRUE)
        ) |>
        ungroup() |>
        mutate(
          tooltip_value = paste0(
            'Month: ', month_name, ' ', year, '\n',
            'Est Value: ', dollar(estimated_value)
          ),
          tooltip_sales = paste0(
            'Month: ', month_name, ' ', year, '\n',
            'Properties Sold: ', comma(homes_sold)
          )
        )
    } else {
      region <- region |>
        mutate(
          month_int = month(period_end),
          month_name = month(period_end, label = TRUE, abbr = TRUE),
          year = year(period_end)
        ) |>
        group_by(period_end, month_int, month_name, year) |>
        summarize(
          estimated_value = mean(estimated_value, na.rm = TRUE),
          homes_sold = sum(homes_sold, na.rm = TRUE),
          total_sales = sum(homes_sold, na.rm = TRUE),
          average_sales = mean(homes_sold, na.rm = TRUE),
          avg_sales_price = mean(median_sale_price, na.rm = TRUE)
        ) |>
        ungroup() |>
        mutate(
          tooltip_value = paste0(
            'Month: ', month_name, ' ', year, '\n',
            'Est Value: ', dollar(estimated_value)
          ),
          tooltip_sales = paste0(
            'Month: ', month_name, ' ', year, '\n',
            'Properties Sold: ', comma(homes_sold)
          )
        )
    }
  })
  
  
  avg_value_change <- reactive({
    change <- region_data() |> 
      filter(
        period_end >= min_date(),
        period_end <= max_date()
      ) |> 
      group_by(year) |> 
      summarize(avg_value = mean(estimated_value, na.rm = TRUE))
    
    if (nrow(change) < 2) return(0)
    
    change <- last(change$avg_value) - first(change$avg_value)
    change
  })
  

  avg_growth_rate <- reactive({
    growth <- region_data() |> 
      filter(
        period_end >= min_date(),
        period_end <= max_date()
      ) |>
      group_by(year) |> 
      summarize(avg_value = mean(estimated_value, na.rm = TRUE)) 
    
    if (nrow(growth) < 2) return(0)  
    
    start_value <- first(growth$avg_value)
    end_value <- last(growth$avg_value)
    num_years <- max(growth$year) - min(growth$year)
    
    if (num_years == 0) return(0)  
    
    growth_rate <- ((end_value / start_value)^(1 / num_years)) - 1
    growth_rate
  })
  
  
  

  
  output$card_sale <- renderValueBox({
    val_card <- avg_growth_rate()
    
    valueBox(
      value = paste0(round(val_card * 100, 2), '%'), 
      subtitle = 'Annual Growth Rate in Estimated Property Value'
    )
  })
  
  
  output$card_val <- renderValueBox({
    val_card <- avg_value_change()
    
    valueBox(
      value = ifelse(is.na(val_card), '-', dollar(val_card)),
      subtitle = 'Change in Average Estimated Property Value'
    )
  })
  
  
  
  output$card_cor <- renderValueBox({
    cor_card <- region_data() 
    cor_card <- cor_card |> 
      filter(
        period_end >= min_date(),
        period_end <= max_date()
      )
    cor_value <- cor(cor_card$estimated_value, cor_card$homes_sold, use = 'complete.obs')
    valueBox(
      value = round(cor_value, 2), 
      subtitle = 'Correlation between Estimated Value and Homes Sold'
    )
  })
  
  
  output$value_line <- renderPlotly({
    plot_value <- region_data() |>
      filter(
        period_end >= min_date(),
        period_end <= max_date()
      ) |>
      ggplot(aes(
        x = period_end,
        y = estimated_value,
        group = 1,
        text = tooltip_value
      )) +
      geom_line() +
      labs(
        title = 'Estimated Average Property Value', 
        x = 'Month and Year'
      ) +
      scale_y_continuous('Estimated Average Value', labels= label_dollar())
    
    ggplotly(plot_value, tooltip = 'text')
  })
  
  
  output$sales_line <- renderPlotly({
    plot_sales <- region_data() |>
      filter(
        period_end >= min_date(),
        period_end <= max_date()
      ) |>
      ggplot(aes(
        x = period_end,
        y = homes_sold,
        group = 1,
        text = tooltip_sales
      )) +
      geom_line() + 
      labs(
        title = 'Total Property Sales', 
        x = 'Month and Year'
      ) +
      scale_y_continuous('Number of Sales', labels= label_comma())
    
    ggplotly(plot_sales, tooltip = 'text')
  })
  
  output$month_bar <- renderPlotly({
    plot_month <- region_data() |>
      filter(
        period_end >= min_date(),
        period_end <= max_date()
      ) |>
      group_by(month_int, month_name) |>
      summarize(
        total_sales = sum(total_sales, na.rm = TRUE),
        # average_sales = mean(total_sales / n_distinct(year), na.rm = TRUE), 
        avg_sales_price = mean(avg_sales_price, na.rm = TRUE)
      ) |>
      mutate(
        tooltip_total_sales = paste0(
          'Month: ', month_name, '\n',
          'Total Properties Sold: ', comma(total_sales)
        ),
        # tooltip_average_sales = paste0(
        #   'Month: ', month_name, '\n',
        #   'Average Properties Sold: ', comma(average_sales)
        # ),
        tooltip_avg_sales_price= paste0(
          'Month: ', month_name, '\n',
          'Average Sales price: ', dollar(avg_sales_price)
        ),
        tooltip_monthly = ifelse(
          input$agg_type == 'total_sales', tooltip_total_sales, tooltip_avg_sales_price
        )
      ) |>
      arrange(month_int) |>
      ggplot(aes(x = month_name, y = get(input$agg_type), fill = month_name, text = tooltip_monthly)) +
      geom_bar(stat = 'identity') + 
      labs(
        title = ifelse(
          input$agg_type == 'total_sales',
          'Total Property Sales by Month',
          'Average Sales Price by Month'
          ),
        x = 'Month', 
        y = ifelse(
          input$agg_type == 'total_sales',
          'Number of Sales',
          'Sales Price'
        ),
        fill = 'Month'
      ) +
      scale_y_continuous(
        labels = ifelse(
          input$agg_type == 'total_sales',
          label_comma(), 
          label_dollar()
        )
        )
    
    ggplotly(plot_month, tooltip = 'text')
  })
  
  
  output$source_text <- renderUI({
    HTML('
      <br>
      <h3>Data Sources</h3>
      <ul>
        <li><a href = "https://www.zillow.com/research/data/">Zillow - ZHVI All Homes Time Series, Smoothed, Seasonally Adjusted ($)</a></li>
        <li><a href = "https://www.redfin.com/news/data-center/">Redfin - Region Data (Metro)</a></li>
      </ul>
    ')
  })
  
  
  output$heading_text <- renderUI({
    HTML("
      <br>
      <h2>A Look Into Tennesse Property Vales and Sales</h2>
      <h3>2012 to 2024</h3>
      <h6 ><em>Let's start exploring Tennessee’s real estate trends!</em></h6>
    ")
  })
  output$intro_text <- renderUI({
    HTML("
      <br>
      <p>This interactive app allows you to explore property valuations, home sales trends, and real estate market behavior across Tennessee.</p>
      <br>
      <h5>App Highlights</h5>
      <ul>
        <li>Track property values and sales over time</li>
        <li>Analyze seasonality in sales volume and sales price</li>
        <li>Look into the relationship between home sales and values</li>
        <li>Compare trends by area and time period</li>
      </ul>
      <br>
      <h5>How To Use:</h5>
      <ul>
        <li>Select a data range</li>
        <li>Select a metro region or all for the whole state</li>
        <li>Property Valuations:</li>  
        <ul>
        <li>Shows trends in valuation and sales</li>
        </ul>
        <li>Sales by Month:</li>
        <ul>
        <li>Shows season patterns with sale volume and price</li>
        </ul>
        <li>Resources has links to data sources used</li>
      </ul>
    ")
  })
  
  
}




