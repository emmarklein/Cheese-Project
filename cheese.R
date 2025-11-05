# install and load libraries
library(ggplot2)
library(dplyr)
library(stringr)
library(tidyr)
library(forcats)
library(purrr)
library(ggpubr)
library(shiny)
library(patchwork)

# tidytugridExtra# tidytuesdayR package for cheese dataset
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

plot1 <- ggplot(cheese_counts, aes(x = reorder(country_clean, n), y = n)) +
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

plot2 <- ggplot(cheese_states_n, aes(x = reorder(state, n), y = n)) +
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
plot3 <- ggplot(milk_country_counts, aes(x = reorder(milk, n), y = n, fill = milk)) +
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

########################### Types of cheese exploration ##########################
cheeses_clean <- cheeses_clean %>%
  mutate(
    main_type = str_trim(str_split_fixed(type, ",", 2)[,1]) # take first descriptor before comma
  )

cheeses_top <- cheeses_clean %>%
  filter(country_clean %in% top_countries) %>%
  count(country_clean, main_type, sort = TRUE) %>%
  group_by(country_clean) %>%
  slice_max(n, n = 5) %>%     # top 5 types per country
  ungroup() %>% filter(!is.na(main_type))

#fix order
cheeses_top <- cheeses_top %>%
  mutate(country_clean = factor(country_clean, levels = country_order))

# barplot per country
plot_bar <- ggplot(cheeses_top, aes(x = reorder(main_type, n), y = n, fill = main_type)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  facet_wrap(~ country_clean, scales = "free_y", ncol = 5) +
  labs(
    title = "Cheese types across the top 5 cheese-producing countries",
    x = "",
    y = "Count"
  ) +
  theme_minimal(base_size = 13)

# let's make it a pie chart for fun!
# Compute proportions per country (so each pie sums to 1)
cheeses_pie <- cheeses_top %>%
  group_by(country_clean) %>%
  mutate(perc = n / sum(n)) %>%
  ungroup()

# Pie chart per country (it's like a cheese wheel haha!)
plot_pie <- ggplot(cheeses_pie, aes(x = "", y = perc, fill = main_type)) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  facet_wrap(~ country_clean, ncol = 5) +
  labs(
    title = " ",
    fill = " "
  ) +
  theme_void(base_size = 13) +
  theme(
    strip.text = element_text(size = 14),
    plot.title = element_text(
      hjust = 0.5, size = 16, margin = margin(b = 10, t = 20)
    ),
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.box = "horizontal",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10),
    legend.spacing.x = unit(0.3, "cm")
  ) +
  guides(fill = guide_legend(nrow = 1))

plot4 <- plot_bar / plot_pie
ggsave("cheese_plots_patchwork.png", plot4, width = 8, height = 10)

## This reveals a very interesting trend. Most of the top 5 cheese producing countries have a good spread of cheese types, but
# France and Canada both have a large proportion of soft cheeses, it's actually a majority of the cheeses produced in these countries.
# I am not surprised by this because France is very famous for its soft cheeses such as Brie and Blue cheese. And many Canadian cheeses are 
#derived from traditional French varieties, reflecting the lasting influence of French colonization in Canada.


########################### vegetarian and vegan curiosities ##########################

## Where do the vegan cheeses come from?
sum(cheeses_clean$vegan, na.rm = TRUE)

## All the vegan cheeses are from the UK...
cheeses_clean %>% filter(vegan == TRUE) %>% select(country_clean)

# Where do the vegetarian cheeses come from?
sum(cheeses_clean$vegetarian, na.rm = TRUE) 
# way more vegetarian cheeses, 429 of them!

# countries that produce vegetarian cheese!
unique(cheeses_clean %>% filter(vegetarian == TRUE) %>% select(country_clean))


########################### Let's look at fat content ##########################

cheeses_fat <- cheeses_clean %>% filter(!is.na(fat_content))

# let's standardize the fat content measurement
cheeses_fat_clean <- cheeses_fat %>%
  mutate(
    fat_percent = case_when(
      # If value is a range like "40-46%"
      str_detect(fat_content, "-") ~ map_dbl(fat_content, function(x) {
        nums <- str_extract_all(x, "\\d+\\.?\\d*")[[1]] %>% as.numeric()
        mean(nums)
      }),
      # If value is a single % like "50%"
      str_detect(fat_content, "%") ~ str_extract(fat_content, "\\d+\\.?\\d*") %>% as.numeric(),
      # If value is g/100g
      str_detect(fat_content, "g/100g") ~ str_extract(fat_content, "\\d+\\.?\\d*") %>% as.numeric(),
      TRUE ~ NA_real_
    )
  )

# Filter to only Soft and Hard cheeses
cheeses_simple <- cheeses_fat_clean %>%
  mutate(
    type_group = case_when(
      str_detect(main_type, "hard") ~ "Hard",
      str_detect(main_type, "soft") ~ "Soft",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(type_group))  # remove anything not Soft or Hard

# Performing t test to see if the difference in hard vs. soft cheese is statistically significant
t_test_result <- t.test(fat_percent ~ type_group, data = cheeses_simple)
t_test_result
p_val <- t_test_result$p.value  # extract p-value
# Format p-value nicely
p_label <- paste0("p = ", signif(p_val, 3))

#p-value = 0.01533! Since p < 0.05, we can say that the difference in fat content between hard and soft cheeses is
# statistically significant. Clearly, the hard cheeses have higher fat content compared to soft cheeses, which makes sense.

# Define cheesy colors for the boxplot
cheese_colors <- c("Soft" = "#FFD966",  # light yellow
                   "Hard" = "#FFA500")  # deeper orange

my_comparisons <- list(c("Soft", "Hard"))

plot5 <- ggplot(cheeses_simple, aes(x = type_group, y = fat_percent, fill = type_group)) +
  geom_boxplot(width = 0.4, alpha = 0.8) +
  scale_fill_manual(values = cheese_colors) +
  labs(
    title = "How does fat content vary between soft and hard cheeses?",
    x = "Cheese Type",
    y = "Fat Content (%)",
    fill = "Cheese Type"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "none",
    plot.title = element_text(hjust = 0.5, face = "bold")
  ) +
  stat_compare_means(
    comparisons = my_comparisons,
    method = "t.test",
    label = "p.signif",      # shows *, **, ***
    tip.length = 0.03,       # length of the horizontal ends of the bracket
    size = 6,                # size of the asterisk
    label.y = max(cheeses_simple$fat_percent) + 5
  ) +
  annotate(
    "text",
    x = 1.5,  # middle between the two boxes (Soft = 1, Hard = 2)
    y = max(cheeses_simple$fat_percent) + 5,  # position above boxes
    label = p_label,
    size = 4
  )

# let's look at fat content across different cheese families
cheese_family_fat <- cheeses_simple %>%
  filter(!is.na(fat_percent), !is.na(family)) %>%
  group_by(family) %>%
  summarize(mean_fat = mean(fat_percent, na.rm = TRUE)) %>%
  arrange(desc(mean_fat))


plot6 <- ggplot(cheese_family_fat, aes(x = reorder(family, mean_fat), y = mean_fat, fill = mean_fat)) +
  geom_col(width = 0.6) +
  coord_flip() +  # makes it easier to read long family names
  scale_fill_gradient(low = "#FFF7AE", high = "#FFB347") +
  labs(
    title = "Average Fat Content by Cheese Family",
    x = "Cheese Family",
    y = "Mean Fat Content (%)"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "none",
    plot.title = element_text(hjust = 0.5, face = "bold")
  )

########################### Let's make a Shiny app ##########################

# i want to make an app so that a user can easily look at each plot!
library(shiny)
library(ggplot2)
library(patchwork) # if you want to combine plots

ui <- fluidPage(
  titlePanel("Cheese Visualizations"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "plot_choice",
        label = "Choose a plot to display:",
        choices = c(
          "Top Countries" = "plot1",
          "US States" = "plot2",
          "Milk Types by Country" = "plot3",
          "Top Cheese Types Bar" = "plot_bar",
          "Top Cheese Types Pie" = "plot_pie",
          "Combined Bar + Pie" = "plot4",
          "Soft vs Hard Fat Content" = "plot5",
          "Fat Content by Family" = "plot6"
        )
      )
    ),
    
    mainPanel(
      plotOutput("cheese_plot", height = "700px")
    )
  )
)

server <- function(input, output, session) {
  
  output$cheese_plot <- renderPlot({
    # Dynamically display the selected plot
    if(input$plot_choice == "plot1") {
      plot1
    } else if(input$plot_choice == "plot2") {
      plot2
    } else if(input$plot_choice == "plot3") {
      plot3
    } else if(input$plot_choice == "plot_bar") {
      plot_bar
    } else if(input$plot_choice == "plot_pie") {
      plot_pie
    } else if(input$plot_choice == "plot4") {
      plot4
    } else if(input$plot_choice == "plot5") {
      plot5
    } else if(input$plot_choice == "plot6") {
      plot6
    }
  })
}

shinyApp(ui, server)

