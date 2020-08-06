
# The aim of this code is to make some basic plots to view the outcomes of the forecast

# Plot the model predicted trends in smoking prevalence by age category, sex and IMD quintile
# and compare these to the estimates from the Health Survey for England

library(data.table)
library(hseclean)
library(stapmr)
library(ggplot2)

# Read the Health Survey for England data
survey_data <- readRDS("intermediate_data/HSE_2001_to_2016_tobacco_imputed.rds")

# Estimate the proportion of smokers for each year, age category, sex and IMD quintile
# with fine stratification takes a while to run
psmk_data <- prop_summary(
    survey_data,
    "smk.state",
    levels_0 = c("former", "never"),
    levels_1 = "current",
    strat_vars = c("year", "age_cat", "sex", "imd_quintile")
  )

setnames(psmk_data, "smk.state", "prop_smoke")

# Plot the observed data
p <- ggplot() +
  geom_point(data = psmk_data, aes(x = year, y = prop_smoke, colour = sex), size = 0.1, alpha = 0.5) +
  geom_ribbon(data = psmk_data, aes(x = year, ymin = prop_smoke - (se * 1.96), ymax = prop_smoke + (se *1.96), fill = sex), alpha = 0.2) +
  facet_wrap(~ imd_quintile + age_cat, nrow = 5) +
  theme_minimal() +
  ylab("proportion smokers") +
  geom_hline(yintercept = 0, size = .1) +
  scale_colour_manual(name = "Sex", values = c("#6600cc", "#00cc99")) +
  scale_fill_manual(name = "Sex", values = c("#6600cc", "#00cc99")) +
  theme(axis.text.x = element_text(angle = 90))
  
# Read the model predictions of smoking
model_data <- fread("output/smk_data_control_basic.txt")
  
# Summarise the proportion of smokers for each year, age category, sex and IMD quintile
model_data[smk.state == "current", smk_bin := 1]
model_data[smk.state %in% c("former", "never"), smk_bin := 0]  

model_data[, age_cat := c("11-15",
                    "16-17",
                    "18-24",
                    "25-34",
                    "35-44",
                    "45-54",
                    "55-64",
                    "65-74",
                    "75-89")[findInterval(age, c(-1, 16, 18, 25, 35, 45, 55, 65, 75, 1000))]]

psmk_model <- model_data[ , .(prop_smoke = mean(smk_bin)), by = c("age_cat", "year", "sex", "imd_quintile")]
  
# Add a line showing the model predictions to the plot
p <- p + geom_line(data = psmk_model, aes(x = year, y = prop_smoke, colour = sex), size = 0.1)

# Add plot information
p <- p + labs(title = "Proportion of people who smoke",
     subtitle = "Data from the Health Survey for England 2001-2016, forecast to 2025", 
     caption = "Points and ribbons show the expected values and 95% confidence intervals from the HSE data. Lines show model predictions.")

# Save the plot
png("output/prop_smokers_simcheck.png", units="in", width=14, height=7, res=500)
  p
dev.off()


# Note: worst fit in 18-25 year olds in the most deprived -
# in estimation of smoking transition probabilities, check fit of parametric model to smoking trends in the HSE

  
  

