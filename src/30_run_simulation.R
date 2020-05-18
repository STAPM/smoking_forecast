
# The aim of this code is to run the simulation of smoking prevalence

# With the following parameters
  # baseline year 2002 (with the starting population informed by a pooled sample from years 2001-2003)
  # starting population size 10,000 people
  # time horizon 2030
  # continuing trends in smoking up to 2030
  # observed trends in mortality to 2016, remaining stationary thereafter except for effects of changes to smoking
  # age range 11-89

library(data.table)
library(stapmr)
library(tobalcepi)

# Load the prepared data on tobacco consumption
behav_data <- fread("output/HSE_2001_to_2016_imputed.csv")

# Create the synthetic population
synthpop <- stapmr::MakePop(
  data_pop = behav_data, # the behaviour dataset
  pop_size = 1e4, # the size of the synthetic population
  baseline_year = 2002, # the starting year of the model
  baseline_sample_years = 2001:2003, # the years of survey data that will inform the synth pop
  n_random_processes = 6, # the number of random processes in the model simulation
  pop_seed = 1, # the random seed for the generation of the synth pop
  pop_keepvars = c( # the variable to keep
    "age",
    "sex",
    "imd_quintile",
    "smk.state",
    "time_since_quit",
    "cigs_per_day",
    "smoker_cat"
  )
)

# Transition probabilities
init_data <- fread("output/init_data.csv")
quit_data <- fread("output/quit_data.csv")
relapse_data <- fread("output/relapse_data.csv")

# Run simulation
sim_run = SmokeSim3(
  behav_data = behav_data,
  init_data = init_data,
  quit_data = quit_data,
  relapse_data = relapse_data,
  baseline_year = 2002,
  baseline_population_size = 1e5,
  time_horizon = 2030,
  trend_limit_mort = 2016,
  trend_limit_smoke = 2030,
  write_outputs = "output"
)





