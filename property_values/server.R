

# Define server logic 
function(input, output, session) {

  # dates are only the last day of the month but allowing any day for selection, so need to change the date to find in the table 
  input_min_date <- ceiling_date(as.Date(input_date[1]), "month") - days(1)
  input_max_date <- ceiling_date(as.Date(input_date[2]), "month") - days(1)
  
   

  
  
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