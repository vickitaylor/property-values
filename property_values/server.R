

# Define server logic
function(input, output, session) {


  # dates are only the last day of the month but allowing any day for selection, so need to change the date to find in the table
  min_date <- reactive({
    min_date <- ceiling_date(as.Date(input$date[1]), "month") - days(1)
  })

  max_date <- reactive({
    max_date <- ceiling_date(as.Date(input$date[2]), "month") - days(1)
  })



  # region to two things, need to rename them to something
  #
  output$value_line <- renderPlotly({
    
    region_data <- reactive({
      region <- values
      
      if(input$region != 'All'){
        region <- region |>
          filter(parent_metro_region == input$region)
      }
      else {
        region <- region |>
          group_by(period_end) |> 
          summarize(estimated_value = mean(estimated_value, na.rm = TRUE))
      }
    })
    
    # region <- 'Nashville, Tn'
    plot_value <- region_data() |>
      filter(period_end >= min_date(),
             period_end <= max_date()) |>
      ggplot(aes(x = period_end, y = estimated_value)) +
      geom_line()
    
    ggplotly(plot_value)
  })


}


# output$distPlot <- renderPlot({
# 
#     # generate bins based on input$bins from ui.R
#     x    <- faithful[, 2]
#     bins <- seq(min(x), max(x), length.out = input$bins + 1)
# 
#     # draw the histogram with the specified number of bins
#     hist(x, breaks = bins, col = 'darkgray', border = 'white',
#          xlab = 'Waiting time to next eruption (in mins)',
#          main = 'Histogram of waiting times')
# 
# })








