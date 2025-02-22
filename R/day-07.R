# Name: Gwyne Morehead-Smith
# Date: 2025-02-21
# Purpose: Read and analyze COVID-19 data

# Load necessary libraries
library(tidyverse)

# Read in COVID-19 data
covid_data <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties-recent.csv")

# Get the most recent date in the dataset
latest_date <- max(covid_data$date)

# Identify the six states with the most cases
top_states <- covid_data %>%
  filter(date == latest_date) %>%
  group_by(state) %>%
  summarise(total_cases = sum(cases, na.rm = TRUE)) %>%
  arrange(desc(total_cases)) %>%
  slice_head(n = 6) %>%
  pull(state) # Extracts state names as a vector

# Filter for only the top 6 states
filtered_data <- covid_data %>%
  filter(state %in% top_states)

# Create the faceted line plot
covid_plot <- ggplot(filtered_data, aes(x = date, y = cases, group = state, color = state)) +
  geom_line() + 
  labs(title = "COVID-19 Cases in the 6 Most Affected States",
       x = "Date",
       y = "Number of Cases",
       color = "State") +
  facet_wrap(~ state, scales = "free_y") +  # Each state gets its own plot
  theme_minimal() # Clean theme

# Ensure img directory exists
if (!dir.exists("img")) dir.create("img")

# Save the plot
ggsave("img/covid_top_states.png", plot = covid_plot, width = 10, height = 6, dpi = 300)
# Summarize total cases per day for the entire USA
usa_daily_cases <- covid_data %>%
  group_by(date) %>%
  summarise(total_cases = sum(cases, na.rm = TRUE))

# Create the column plot
usa_cases_plot <- ggplot(usa_daily_cases, aes(x = date, y = total_cases)) +
  geom_col(fill = "steelblue") +  # Bar color
  labs(title = "Daily Total COVID-19 Cases in the USA",
       x = "Date",
       y = "Number of Cases") +
  theme_minimal() # Clean theme

# Ensure img directory exists
if (!dir.exists("img")) dir.create("img")

# Save the plot
ggsave("img/usa_daily_cases.png", plot = usa_cases_plot, width = 10, height = 6, dpi = 300)
