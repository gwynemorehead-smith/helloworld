# Name: Gwyne Morehead-Smith
# Date: 2025-02-21
# Purpose: Read and analyze COVID-19 data

# Load necessary package
library(readr)

# Read in COVID-19 data
covid_data <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties-recent.csv")
# View first few rows of the dataset
head(covid_data)