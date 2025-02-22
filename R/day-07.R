# Name: Gwyne Morehead-Smith
# Date: 2025-02-21
# Purpose: Read and analyze COVID-19 data

# Load necessary libraries
library(tidyverse)

# Read in COVID-19 data
covid_data <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties-recent.csv")

library(tidyverse)

# Identify top 6 states
top_states <- covid_data %>%
  group_by(state) %>%
  summarize(total_cases = max(cases, na.rm = TRUE)) %>%
  arrange(desc(total_cases)) %>%
  slice_head(n = 6) %>%
  pull(state)

# Filter data for those states
filtered_data <- covid_data %>%
  filter(state %in% top_states) %>%
  group_by(state, date) %>%
  summarize(daily_cases = sum(cases, na.rm = TRUE)) %>%
  ungroup()

# Plot
ggplot(filtered_data, aes(x = as.Date(date), y = daily_cases, color = state)) +
  geom_line() +
  facet_wrap(~state, scales = "free_y") +
  theme_minimal() +
  labs(title = "COVID-19 Cases in Top 6 States",
       x = "Date",
       y = "Daily Cases")

ggsave("img/covid_top_states.png")
library(tidyverse)

# Ensure date is correctly formatted
covid_data <- covid_data %>%
  mutate(date = as.Date(date))

# Compute daily new cases (difference from the previous day)
usa_cases <- covid_data %>%
  arrange(date) %>%
  group_by(state) %>%
  mutate(daily_cases = cases - lag(cases, default = first(cases))) %>%
  ungroup() %>%
  group_by(date) %>%
  summarize(total_daily_cases = sum(daily_cases, na.rm = TRUE))

# Plot
ggplot(usa_cases, aes(x = date, y = total_daily_cases)) +
  geom_col(fill = "steelblue") +
  theme_minimal() +
  labs(title = "Daily COVID-19 Cases in the USA",
       x = "Date",
       y = "New Cases")

ggsave("img/usa_daily_cases.png")

