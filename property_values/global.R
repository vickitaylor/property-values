

# importing libraries used
library(shiny)
library(tidyverse)
library(glue)
library(DT)
library(plotly)
library(lubridate)
library(bslib)
library(scales)
library(shinydashboard)




values <- read_csv('data/TN_sales.csv')


min_date <- values |> 
  summarize(min_date = min(period_end)) |> 
  pull(min_date)

max_date <- values |> 
  summarize(max_date = max(period_end)) |> 
  pull(max_date)


values <- values |> 
  mutate(
    month_int = month(period_end),
    month_name = month(period_end, label = TRUE, abbr = TRUE),
    year = year(period_end)
  )
