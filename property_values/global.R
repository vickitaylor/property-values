

# importing libraries used
library(shiny)
library(tidyverse)
library(glue)
library(DT)
library(plotly)
library(lubridate)
library(bslib)


values <- read_csv('../data/Tn_sales.csv')


min_date <- values |> 
  summarize(min_date = min(period_end)) |> 
  pull(min_date)

max_date <- values |> 
  summarize(max_date = max(period_end)) |> 
  pull(max_date)
