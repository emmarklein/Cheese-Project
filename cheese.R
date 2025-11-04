# install and load libraries
library(ggplot2)
library(dplyr)
library(stringr)
library(tidyr)
library(forcats)

# tidytuesdayR package for cheese dataset
install.packages("tidytuesdayR")
tuesdata <- tidytuesdayR::tt_load('2024-06-04')

# cheese data
cheeses <- tuesdata$cheeses

# Let's explore the dataset!

########################### Cheeses per country ##########################
# UK is written in many different ways, let's standardize it
country_keywords <- c(
  "United Kingdom" = "United Kingdom",
  "England" = "United Kingdom",
  "Scotland" = "United Kingdom",
  "Wales" = "United Kingdom",
  "Great Britain" = "United Kingdom",
  "Holland" = "Netherlands"
)

## function to clean the country column
clean_country <- function(df, country_col = "country") {
  df %>%
    # Split multi-country entries first
    separate_rows(.data[[country_col]], sep = ",\\s*") %>%
    mutate(country_clean = str_trim(.data[[country_col]])) %>%
    rowwise() %>%
    mutate(
      country_clean = {
        match <- names(country_keywords)[str_detect(country_clean, regex(names(country_keywords), ignore_case = TRUE))]
        if(length(match) > 0) country_keywords[match[1]] else country_clean
      }
    ) %>%
    ungroup() %>%
    filter(!is.na(country_clean))
}

# Apply function
cheeses_clean <- clean_country(cheeses)

# Cheese production across different countries
cheese_counts <- cheeses_clean %>%
  count(country_clean, sort = TRUE) %>%
  filter(!is.na(country_clean)) %>% 
  slice_max(n, n = 20)

ggplot(cheese_counts, aes(x = reorder(country_clean, n), y = n)) +
  geom_col(fill = "goldenrod") + #cheesy color
  geom_text(aes(label = n), 
            hjust = -0.1,
            size = 4) +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(
    x = " ",
    y = "Types of cheese",
    title = "Which countries produce the most cheese varieties?"
  ) 

########################### Cheese type per US region ##########################

# Let's focus on the US and check out the cheese production by region
cheese_US <- cheeses_clean %>%
  filter(str_detect(country_clean, "United States")) %>% 
  filter(!is.na(region)) #we need this info

# US state names and abbreviations
states_full <- state.name
states_abbr <- state.abb
state_lookup <- setNames(state.name, state.abb)

# Cleaning function to fix the region naming
clean_region <- function(region_col) {
  sapply(region_col, function(x) {
    if (is.na(x)) return(NA)
    
    x_clean <- str_trim(x)
    
    # 1. Match full state name anywhere in the string
    full_match <- states_full[str_detect(x_clean, regex(states_full, ignore_case = TRUE))]
    if (length(full_match) > 0) return(full_match[1])
    
    # 2. Match exact state abbreviation (whole word, case-insensitive)
    abb_match <- states_abbr[str_detect(x_clean, regex(paste0("\\b", states_abbr, "\\b"), ignore_case = TRUE))]
    if (length(abb_match) > 0) return(state_lookup[abb_match[1]])
    
    # 3. If no state match, leave original
    return(x_clean)
  })
}

# Apply to dataset and only include US states as regions
cheesy_states <- cheese_US %>%
  mutate(state = clean_region(region)) %>%
  filter(state %in% state.name)

# Cheese production across different regions in the US, same counting as before
cheese_states_n <- cheesy_states %>%
  count(state, sort = TRUE)

ggplot(cheese_states_n, aes(x = reorder(state, n), y = n)) +
  geom_col(fill = "#FFA600") + #cheddar orange color
  geom_text(aes(label = n), 
            hjust = -0.1,
            size = 4) +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(
    x = " ",
    y = "Types of cheese",
    title = "Which US states produce the most cheese varieties?"
  ) 

## Wow wisconsin produces a LOT of different types of cheese!

########################### Types of milk exploration ##########################
# cleaning milk type column
cheeses_milk_split <- cheeses_clean %>%
  separate_rows(milk, sep = ",\\s*") %>%
  mutate(milk = str_trim(milk)) %>%
  filter(!is.na(milk))

# Getting the top 10 countries by number of cheeses
top_countries <- cheeses_milk_split %>%
  count(country_clean, sort = TRUE) %>%
  slice_max(n, n = 5) %>%
  pull(country_clean)

# Filter and count milk types for only those countries
milk_country_counts <- cheeses_milk_split %>%
  filter(country_clean %in% top_countries) %>%
  count(country_clean, milk, sort = TRUE)

# reorder countries by total cheese count
country_order <- milk_country_counts %>%
  group_by(country_clean) %>%
  summarise(total = sum(n)) %>%
  arrange(desc(total)) %>%
  pull(country_clean)

milk_country_counts <- milk_country_counts %>%
  mutate(country_clean = factor(country_clean, levels = country_order))

# Plot one barplot per country, ordered by total cheese types
ggplot(milk_country_counts, aes(x = reorder(milk, n), y = n, fill = milk)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = n), 
            hjust = -0.1,
            size = 4) +
  facet_wrap(~ country_clean, scales = "free_y", ncol =5) +
  coord_flip() +
  labs(
    title = "Milk types used in cheese across the world",
    x = "Milk type",
    y = "Number of cheeses"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    strip.text = element_text(face = "bold"),
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5)
  )

# Interesting... most cheeses in different the most cow milk





