# Define server logic
function(input, output, session) {
  # dates are only the last day of the month but allowing any day for selection, so need to change the date to find in the table
  min_date <- reactive({
    min_date <- ceiling_date(as.Date(input$date[1]), "month") - days(1)
  })
  
  max_date <- reactive({
    max_date <- ceiling_date(as.Date(input$date[2]), "month") - days(1)
  })
  
  region_data <- reactive({
    region <- values
    
    if (input$region != "All") {
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
          average_sales = mean(homes_sold, na.rm = TRUE)
        ) |>
        ungroup() |> 
        mutate(
          tooltip_value = paste0(
            'Month: ', month_name, ' ', year, '\n', 
            'Est Value: ', dollar(estimated_value)), 
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
          average_sales = mean(homes_sold, na.rm = TRUE)
        ) |>
        ungroup() |> 
        mutate(
          tooltip_value = paste0(
            'Month: ', month_name, ' ', year, '\n', 
            'Est Value: ', dollar(estimated_value)), 
          tooltip_sales = paste0(
            'Month: ', month_name, ' ', year, '\n', 
            'Properties Sold: ', comma(homes_sold)
          )
        )
    }
  })
  
  # region to two things, need to rename them to something
  #
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
      geom_line()
    
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
      geom_line() 
    
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
        average_sales = mean(total_sales / n_distinct(year), na.rm = TRUE)
      ) |>
      arrange(month_int) |>
      ggplot(aes(x = month_name, y = get(input$agg_type), fill = month_name)) +
      geom_bar(stat = "identity")
    
    ggplotly(plot_month)
  })
}
