# 1) Install & load needed packages
install.packages(c("readxl", "dplyr", "janitor", "ggplot2"))
library(readxl)
library(dplyr)
library(janitor)
library(ggplot2)

# 2) Read & clean names
df <- read_excel("Nutrients.xlsx") %>% 
  clean_names()  
# Now names(df) will be syntactic, e.g.
# "fct_code", "food_name", "bengali_name", "energy_kcal", 
# "protein_g", "fat_g", "carbohydrate_available_g", ...

# 3) (Optional) Check your names:
print(names(df))

# 4) Compute total macronutrient weight & energy density
df <- df %>%
  mutate(
    total_macro        = protein_g + fat_g + carbohydrate_available_g,
    energy_density_kpg = energy_kcal / total_macro
  )

# 5) Select top 10 by density
top10 <- df %>%
  arrange(desc(energy_density_kpg)) %>%
  slice_head(n = 10)

# 6) Plot
ggplot(top10, aes(x = reorder(food_name, energy_density_kpg), y = energy_density_kpg)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(  x     = NULL, 
    y     = "Energy Density"
  ) +
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title    = element_text(size = 16, face = "bold", family = "Arial"),
    axis.title    = element_text(size = 12, family = "Arial"),
    axis.text     = element_text(size = 10, family = "Arial"),
    panel.grid.minor = element_blank()
  )

# 7) Save the figure

ggsave(
  filename = "energy_density_top10.png",
  path     = "outputs",
  width    = 8,
  height   = 5,
  dpi      = 300
)
