
# The aim of this code is to run the simulation of smoking prevalence

library(data.table)
library(stapmr)
library(tobalcepi)

# Load data ----------------

# Load the prepared data on tobacco consumption
survey_data <- fread("intermediate_data/HSE_2001_to_2016_imputed.csv")

# Transition probabilities
init_data <- fread("intermediate_data/init_data.csv")
quit_data <- fread("intermediate_data/quit_data.csv")
relapse_data <- fread("intermediate_data/relapse_data.csv")

# Mortality data
mort_data <- readRDS("intermediate_data/tob_mort_data_cause.rds")

# Run simulation ----------------

# This is a basic single arm simulation
  # from 2002 to 2025
  # 1000 people

SmokeSim_forecast(
  survey_data = survey_data,
  init_data = init_data,
  quit_data = quit_data,
  relapse_data = relapse_data,
  mort_data = mort_data,
  baseline_year = 2002,
  baseline_sample_years = 2001:2003, # synth pop is drawn from 3 years
  time_horizon = 2025,
  pop_size = 1e3,
  pop_data = stapmr::pop_counts,
  two_arms = FALSE,
  init_data_adj = NULL,
  quit_data_adj = NULL,
  seed_sim = NULL,
  pop_seed = 1,
  iter = NULL,
  write_outputs = "output",
  label = "basic"
)





