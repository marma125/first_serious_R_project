setwd("C:/Users/maxma/OneDrive/R_Projects/first_serious_R_project")
library(tidyverse)

#read data
magsus <- read_delim("data/GeoB6425-2_susceptibility_age.tab",
            na = c("", "NA"), 
            skip = 15)  %>%
  rename(depth = "Depth [m]", 
         age = "Age [ka BP]", 
         kappa = "kappa [10**-6 SI]") %>%
  select(depth, kappa)

magsus

h2o_dens <- read_delim("data/GeoB6425-2_water_density.tab",
                     na = c("", "NA"), 
                     skip = 16) %>%
  rename(depth = "Depth [m]", watercont = "Water wm [%]", 
         poros = "Poros [% vol]",
         dbd = "DBD [g/cm**3]",
         wbd = "WBD [g/cm**3]") %>%
  select(-dbd, -wbd)

h2o_dens
