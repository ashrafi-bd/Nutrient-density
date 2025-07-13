# calc_nutrient_metrics.R

# ─── 1) Install & load packages ───────────────────────────────────────────────
library(readxl)
library(dplyr)
library(janitor)
library(ggplot2)

# 2) Read the Excel file and clean column names
df <- read_excel("Nutrients.xlsx") %>%
  clean_names()
# Confirm the names
#print(names(df))

# 3) Compute protein per 100 kcal
df <- df %>%
  mutate(
    protein_per_100kcal = (protein_g / energy_kcal) * 100
  )

# 4) (Optional) Create outputs folder
if (!dir.exists("outputs")) dir.create("outputs")

# 5) Plot protein per 100 kcal for all foods
p <- ggplot(df, aes(x = reorder(food_name, protein_per_100kcal), 
                    y = protein_per_100kcal)) +
  geom_col(fill = "tomato") +
  coord_flip() +
  labs(
    x     = NULL,
    y     = "Protein (g) per 100 kcal",
    title = "Protein per 100 kcal"
  ) +
  theme_minimal(base_family = "Arial") +
  theme(
    panel.grid.minor = element_blank(),
    plot.title     = element_text(size = 16, face = "bold")
  )

# 6) Display the plot
print(p)

# 7) Save the plot to outputs/
ggsave(
  filename = "protein_per_100kcal_all.png",
  plot     = p,
  path      = "outputs",
  width     = 8,
  height    = 6,
  dpi       = 300
)