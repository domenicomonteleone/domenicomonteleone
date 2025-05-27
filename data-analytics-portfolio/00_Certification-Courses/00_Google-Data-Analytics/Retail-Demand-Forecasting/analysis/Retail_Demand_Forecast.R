## ----setup, include=FALSE---------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = FALSE, warning = FALSE)
library(knitr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(scales)
library(tidyr)
library(DT)
library(formattable)
library(tidyverse)
library(reactable)
library(htmltools)


## ----load-clean, echo=FALSE, results='hide'---------------------------------------------------------------------------------

df <- read.csv("data/Historical_Product_Demand.csv", stringsAsFactors = FALSE)

colnames(df) <- gsub(" ", "_", tolower(colnames(df)))
df$order_demand <- as.numeric(gsub("[()]", "-", df$order_demand))
df$date <- as.Date(df$date)
df <- df %>% filter(!is.na(order_demand), !is.na(date))
Sys.setlocale("LC_TIME", "en_US.UTF-8")
df$month <- floor_date(df$date, "month")


## ----monthly-demand---------------------------------------------------------------------------------------------------------

monthly_demand <- df %>%
  group_by(month) %>%
  summarise(total_demand = sum(order_demand, na.rm = TRUE) / 1e6)

# Grafico originale (identico al tuo)
p <- ggplot(monthly_demand, aes(x = month, y = total_demand)) +
  geom_line(color = "#3498DB", linewidth = 1) +
  geom_point(color = "#E74C3C", size = 2) +
  scale_y_continuous(labels = label_number(suffix = "M"), name = "Total Demand (in millions)") +
  labs(title = "Aggregated Monthly Demand", x = "Month", y = "Total Demand (Mega)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_text(angle = 45, hjust = 1))

# 
p

# Export automatico (aggiunto in fondo, senza modifiche al grafico)

ggsave(
  filename = "images/01_monthly_demand.png", 
  plot = p,  # 
  width = 10, 
  height = 6, 
  dpi = 300,
  bg = "white"
)



## ----seasonality, message=FALSE---------------------------------------------------------------------------------------------

# Preparazione dati originale
df$year <- year(df$date)
df$month_name <- month(df$date, label = TRUE)

seasonality <- df %>%
  group_by(year, month_name) %>%
  summarise(monthly_demand = sum(order_demand, na.rm = TRUE) / 1e6)

# 
seasonality_plot <- ggplot(seasonality, 
                          aes(x = month_name, 
                              y = monthly_demand, 
                              group = year, 
                              color = factor(year))) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_y_continuous(labels = label_number(suffix = "M"), 
                    name = "Demand (in millions)") +
  labs(title = "Demand Seasonality by Year", 
       x = "Month", 
       y = "Demand (Mega)", 
       color = "Year") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom")

# 
seasonality_plot

ggsave(
  filename = "images/02_seasonality_by_year.png",
  plot = seasonality_plot,
  width = 10,
  height = 6,
  dpi = 300,
  bg = "white"  
)


## ----3-6 months noving average----------------------------------------------------------------------------------------------
# Calculate moving averages
monthly_demand <- monthly_demand %>%
  arrange(month) %>%
  mutate(
    moving_avg_3 = zoo::rollmean(total_demand, k = 3, fill = NA, align = "right"),
    moving_avg_6 = zoo::rollmean(total_demand, k = 6, fill = NA, align = "right")
  )

# Plot with both moving averages
moving_avg_plot <- ggplot(monthly_demand, aes(x = month)) +
  geom_line(aes(y = total_demand), color = "steelblue", size = 1) +
  geom_line(aes(y = moving_avg_3), color = "darkred", linetype = "dashed", size = 1, alpha = 0.8) +
  geom_line(aes(y = moving_avg_6), color = "forestgreen", linetype = "dotdash", size = 1, alpha = 0.8) +
  labs(
    title = "Forecast with 3- and 6-Month Moving Averages",
    x = "Month",
    y = "Demand",
    caption = "Blue = Actual Demand | Red = 3-Month MA | Green = 6-Month MA"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# Display the plot
moving_avg_plot

# Export to file
ggsave(
  filename = "images/03_06_moving_average_forecast.png",
  plot = moving_avg_plot,
  width = 10,
  height = 6,
  dpi = 300,
  bg = "white"
)




## ----top 5 products---------------------------------------------------------------------------------------------------------

# 
top5_products <- df %>%
  group_by(product_code) %>%
  summarise(total_demand = sum(order_demand, na.rm = TRUE)) %>%
  arrange(desc(total_demand)) %>%
  slice_head(n = 5) %>%
  pull(product_code)

# 
df_top5 <- df %>%
  filter(product_code %in% top5_products) %>%
  group_by(product_code, month) %>%
  summarise(monthly_demand = sum(order_demand, na.rm = TRUE), .groups = "drop")

#
top5_plot <- ggplot(df_top5, aes(x = month, y = monthly_demand, 
                               color = product_code, group = product_code)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2, alpha = 0.7) +  
  labs(
    title = "Monthly Demand Trend - Top 5 Products",
    subtitle = "Products with highest total demand",
    x = "Month",
    y = "Total Demand (in Millions)",
    color = "Product Code"
  ) +
  scale_y_continuous(
    labels = scales::label_number(scale = 1e-6, suffix = "M"),
    breaks = scales::pretty_breaks(n = 6)  # Migliore scala sull'asse Y
  ) +
  scale_color_viridis_d(option = "D", end = 0.9) +  # Scala colore accessibile
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    plot.subtitle = element_text(hjust = 0.5, color = "gray50"),
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  ) +
  guides(color = guide_legend(nrow = 1))  # 

# 
top5_plot

# 


ggsave(
  filename = "images/04_top5_demand_plot.png",
  plot = top5_plot,
  width = 10, 
  height = 6,
  dpi = 300,
  bg = "white"
)



## ----Annual Demand by Warehouse and Product Category------------------------------------------------------------------------
pivot_data <- df %>%
  mutate(year = year(date)) %>%
  group_by(warehouse, product_category, year) %>%
  summarise(demand = sum(order_demand, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = year, values_from = demand, values_fill = 0) %>%
  mutate(Total = rowSums(across(where(is.numeric))))

min_val <- min(select(pivot_data, where(is.numeric)), na.rm = TRUE)
max_val <- max(select(pivot_data, where(is.numeric)), na.rm = TRUE)

color_cell <- function(value) {
  palette <- colorRampPalette(c("#FFF9C4", "#FF9800", "#D32F2F"))(100)
  norm <- round(99 * (value - min_val) / (max_val - min_val)) + 1
  div(style = paste0("background-color:", palette[norm], "; padding: 2px 6px; border-radius: 4px; font-size: 11px; text-align: right;"), format(value, big.mark = ","))
}

year_cols <- setdiff(names(pivot_data), c("warehouse", "product_category", "Total"))

col_defs <- list(
  warehouse = colDef(name = "Warehouse", filterable = TRUE, minWidth = 100),
  product_category = colDef(name = "Product Category", filterable = TRUE, minWidth = 120),
  Total = colDef(name = "Total", cell = color_cell, sortable = TRUE, filterable = FALSE, minWidth = 80)
)

for (col in year_cols) {
  col_defs[[col]] <- colDef(filterable = FALSE, cell = color_cell, sortable = TRUE, minWidth = 80)
}

reactable(
  pivot_data,
  filterable = TRUE,
  searchable = FALSE,
  striped = TRUE,
  highlight = TRUE,
  resizable = TRUE,
  defaultPageSize = 20,
  columns = col_defs,
  defaultSorted = "Total",
  defaultSortOrder = "desc",
  style = list(fontSize = "11px", width = "100%")
)


## ----export for Tableau, echo = TRUE----------------------------------------------------------------------------------------
write.csv(df, "data/tableau/Historical_Product_Demand_Tableau.csv", row.names = FALSE)


