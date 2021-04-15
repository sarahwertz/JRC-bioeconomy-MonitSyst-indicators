# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# EU strategy objective 1  (so1) - Ensuring food and nutrition security
# +001 DOWNLOAD DATA
# +002 PREPARE & READ  DATA
#      1.1.a.1 - Agricultural factor income per annual work unit
#      1.1.a.4 - Total biomass supply for food purposes, including inputs
#      1.1.b.1 - Prevalence of moderate or severe food insecurity in the total population, yearly estimates 
#      1.1.c.1 - Daily calorie supply per capita by source
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Load configuration variables
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library(dplyr)
library(tidyr)
library(purrr)
#install.packages("corrr")
library(corrr)
library(ggplot2)
library(base)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +001 DOWNLOAD DATA
#BitBucket repository : Bioeconomy Knowledge Centre / biomon-data
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#clone repository
#on the command prompt:
#git clone https://citnet.tech.ec.europa.eu/CITnet/stash/scm/beo/biomon-data.git
#cd folder-in-which-you-download-data
#git checkout --track origin/develop

# +002 PREPARE & READ  DATA
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# - 1.1.a.1 - Agricultural factor income per annual work unit  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
awu <- read.csv(paste0(cordir_in,"output_data/indicators/1.1.a.1/1.1.a.1.csv"), stringsAsFactors = FALSE)
awu
names(awu)
names(awu)[3] <- "awu"
names(awu)[4] <- "unit_awu"

unique(awu$geo_code)
options(max.print = 1000 * ncol(awu))
awu <- awu %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

levels(as.factor(awu$unit_awu))

# - 1.1.a.4 - Total biomass supply for food purposes, including inputs 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
biom_food <- read.csv(paste0(cordir_in, "output_data/indicators/1.1.a.4/1.1.a.4.csv"), stringsAsFactors = FALSE) 
str(biom_food)
names(biom_food)
names(biom_food)[3] <- "biomass.food"
names(biom_food)[4] <- "unit_index.2010.100"
names(biom_food)

unique(biom_food$geo_code)
options(max.print = 1000 * ncol(biom_food))
biom_food           <- biom_food %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

levels(as.factor(biom_food$unit_index.2010.100))

# - 1.1.b.1 - Prevalence of moderate or severe food insecurity in the total population, yearly estimates 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
food_insecurity <- read.csv(paste0(cordir_in,"output_data/indicators/1.1.b.1/1.1.b.1.csv"), stringsAsFactors = FALSE) 
food_insecurity
names(food_insecurity)
names(food_insecurity)[3] <- "food.insecurity"
names(food_insecurity)[4] <- "unit_food.insecurity"

unique(food_insecurity$geo_code)
options(max.print = 1000 * ncol(food_insecurity))
food_insecurity           <- food_insecurity %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

levels(as.factor(food_insecurity$unit_food.insecurity))

# - 1.1.c.1 - Daily calorie supply per capita by source
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
calorie_supply <- read.csv(paste0(cordir_in,"output_data/indicators/1.1.c.1/1.1.c.1.csv"), stringsAsFactors = FALSE)
calorie_supply
names(calorie_supply)
names(calorie_supply)[3] <- "calorie_supply"
names(calorie_supply)[4] <- "unit_calorie_supply"
calorie_supply <- calorie_supply[-5]

unique(calorie_supply$geo_code)
options(max.print = 1100 * ncol(calorie_supply))
calorie_supply           <- calorie_supply %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

levels(as.factor(calorie_supply$unit_calorie_supply))
calorie_supply_animal   <- calorie_supply %>% filter(unit_calorie_supply %in% c("ANI"))
calorie_supply_vegetal  <- calorie_supply %>% filter(unit_calorie_supply %in% c("VEG"))

names(calorie_supply_animal)[3]   <- "calorie_supply_animal"
names(calorie_supply_animal)[4]   <- "unit.calorie_supply_animal"
names(calorie_supply_vegetal)[3]  <- "calorie_supply_vegetal"
names(calorie_supply_vegetal)[4]  <- "unit.calorie_supply_vegetal"