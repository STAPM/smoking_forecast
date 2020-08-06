# Example workflow for forecasting smoking prevalence
The code in this repo is part of the STAPM programme of modelling. STAPM was created as part of a programme of work on the health economics of tobacco and alcohol at the School of Health and Related Research (ScHARR), The University of Sheffield. This programme is based around the construction of the Sheffield Tobacco and Alcohol Policy
Model (STAPM), which aims to use comparable methodologies to evaluate the impacts of tobacco and alcohol policies, and investigate the consequences of clustering and interactions between tobacco and alcohol consumption behaviours. See the [STAPM webpage](https://stapm.gitlab.io/).   

The code in this repo is designed to support our analyst team to understand how to run the model - by providing a worked example of the entire workflow. This example is a forecast of smoking prevalence to 2025. Developments are still being worked through, so the code in this repo is likely to change. The code and documentation are still undergoing internal review by the analyst team. At the moment only members of our project team are able to run this code because it depends on a number of private R packages.    

## Code
The code depends on a number of private R packages. To access these packages you will need to sign-up for a Gitlab account and then let Duncan Gillespie know your username so that you can be added to our team. You can then install the packages by running the code file `src/05_install_packages.R`. Note that you will need to replace the username in the code with your own and you will then need to type your Gitlab password into the box when it appears. See our [range of R packages](https://stapm.gitlab.io/software.html).       

To run the model yourself, you will need to 'clone' the code in this repo to your own computer -- we have made [a video to show how to do this](https://digitalmedia.sheffield.ac.uk/media/1_ji3vrs1s). If you can get this example running on your own machine, then you are ready to move onto more complex things that can be done with the smoking model.      

## Data
There are two options for getting access to the data required to run the code in this repo.  

**If you want to create the data inputs from the raw data**, then you will need to be given access to the University of Sheffield's X-drive folders `PR_Consumption_TA` and `PR_mortality_data_TA`. This will allow you to run the code files `10_clean_hse.R`, `15_prep_mortality.R` and `20_estimate_smoking_transition_probabilities.R`.    

**You can use ready-made data to run the model**. The data files that you will need are stored in the X-drive folder `PR_STAPM/Data/smoking_forecast`. Copy the files there to the folder `intermediate_data`. You can then run the code `30_run_simulation.R` without having to run the code files that create the data inputs.  

The **inputs** are:   

1.  A population data sample with details of tobacco consumption from the Health Survey for England. These data are for ages 11--89 years and years 2001--2016. The data have had missing values for key socio-economic variables imputed.   
2.  Smoking transition probabilities - three files covering smoking initiation, quitting and relapse.   
3.  Cause-specific rates of mortality that have been forecast into the future.  

## Model processes
The model is run by the function `stapmr::SmokeSim_forecast()`. This function can recapitulate the past trends in smoking observed in the HSE, allowing validation of the model predictions against the observed data. It also allows the forecasting of future smoking, based on our forecasts of the continuing trends in mortality and in the smoking transition probabilities.    

The smoking model is an individual-based simulation of the population dynamics of smoking (see the [mathematical model framework](https://stapm.gitlab.io/stapmr/articles/smoking_model_maths.html)). The model simulates individual movements among current, former and never smoking states as they age. The simulation proceeds in one year time steps. At each time step, a sample of new individuals are added to the simulated population at the youngest age of 11 years. In each year of the simulation, **survival** is simulated by assigning each individual a relative risk for each disease based on their smoking state; individuals are then removed from the population according to their probabilities of death from each disease, accounting for differential risk by smoking status. **Behaviour change** is simulated in terms of individual transitions among smoking states, and time since quitting for former smokers is updated; each individual is assigned the smoking transition probability that matches their age, sex and IMD quintile for the year being simulated. **Demographic change** is simulated by ageing individuals by one year, and adding new individuals at the youngest age; the number of individuals added at the youngest age in each year is proportional to either the observed or [projected population sizes](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationprojections) (based on the primary population projection) for that age and year.    

The whole model is stratified by sex and socio-economic conditions (where we define socio-economic conditions in terms of Index of Multiple Deprivation quintiles).     

## Output
The main **output** of these processes is a simulated individual-level dataset of tobacco consumption from the baseline year (2002) to the time horizon of the forecast (2025). The code file `40_plot_results.R` plots the model predicted trends in the proportion of smokers against the observed values from the Health Survey for England and shows how the predicted trend is likely to continue in the future. The plot of trends is stratified by age-category, sex and IMD quintile.   

