# Tennessee Metro Property Valuation Analysis 


## Summary 
This project focuses on understanding market volatility in real estate within Tennessee metro areas. Using property valuation and sale data to identify trends and relationships between property sales and valuations within the metro areas. Findings will be presented in an interactive Shiny application.  

## Motivation 
I have worked in the housing industry for over ten years, and I am looking to explore trends and relationships in valuations and property sales. Upon completion of the project, I am looking to apply what I learned to my current position which is focused on consumer behavior and recapturing their business. 

## App
[Property Value App](https://vickitaylor.shinyapps.io/property_values/)  

Property Valuation Tab
- Displays how property values and sales have changed over time for selected area.
- Select date range from 01/31/2012 to 12/31/24
- Select metro region in Tennessee or all regions in the state. 
- The average estimated value, average properties sold, and value to sales correlation will be displayed with line charts for estimated valuation and sales by month for the selected dates and region. 

Monthly Sales Tab 
- Shows sales by month to see if the time of the year has an affect for sales. 
- Date and Metro selections from prior tab are available, with a selection for either total sales, or average sales. Included option to see if there was a difference between the two.


## Data Questions
1.	How has median property values changed over time for the area?
2.	How has the number of sales changed over time?
3.	Is there seasonality for property sales, and does it affect property valuation?
<!-- Stretch Questions (not for mvp): 
1.	How do property values compare to median income over time?
2.	What area shows the largest property appreciation rate?
3.	Is there a valuation-to-income ratio across areas? Is it significant?
4.	Do mortgage interest rates influence property values and number of sales?
5.	Is there any areas with higher market volatility? 
6.	How do property values for an area compare to state trends?  -->


## Insights 
- 
- Weak correlation between valuation and sales. 
    - For the whole time period Nashville was least correlated and Morristown had the strongest. (Note: correlation will change with the time period is decreased) 
- Summer months have a higher 

## Data Sources
- Valuation, used file ZHVI All Homes Time Series, Smoothed, Seasonally Adjusted($) - [Zillow](https://www.zillow.com/research/data/)
- Sales - used Metro region data - [Redfin](https://www.redfin.com/news/data-center/)  

Notes: 
- Not all regions started on 01/31/12
- Dropped regions that were not in both data sets (there were one in each dataset that data was not available for int the other.)
- Used data on the Metropolitan Statistical Area (MSA) level. MSAs are US government designations that describe urban areas with a population over 50,000. It includes the surrounding areas that have economic ties to the main metro area.
<!-- - Mortgage rates over time- https://fred.stlouisfed.org/series/MORTGAGE30US
- Median income by metro area - https://www.bea.gov/data/income-saving/personal-income-county-metro-and-other-areas -->


## Technology Used
- Python
- R
- Shiny 


## Future Additions
- Include median income from [BEA](https://www.bea.gov/data/income-saving/personal-income-county-metro-and-other-areas) to see how income for a region affects value and sales. 
- See if mortgage rates have any affect with values and sales, pulling rates from [FRED](https://fred.stlouisfed.org/series/MORTGAGE30US)




