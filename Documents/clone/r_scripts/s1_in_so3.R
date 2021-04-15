# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# EU strategy objective 3  (so3) - Reducing dependance on non-renewable unsustainable sources
# whether sourced domestically or from abroad
# +001 DOWNLOAD DATA
# +002 PREPARE & READ  DATA
#      3.1.a.1 - Domestic Material Consumption (Biomass) - Thousand tonnes (1000T) 
#      3.1.a.2 - Material footprint (Biomass) - Tonne per capita 
#      3.1.b.1 - Energy productivity - eur/kg of oil equivalent
#      3.1.b.2 - Share of renewable energy in gross final energy consumption - Percent (%)
#      3.1.c.2 - Circular material rate - percent (% of total material use)
#      3.4.a.2 - Total biomass consumed for energy - 1000 T of Dry Matter 
#      3.4.a.3 - Total biomass consumed for materials - 1000 T of Dry Matter
#      3.4.a.4 - Share of woody biomass used for energy
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Load configuration variables
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library(dplyr)
library(tidyr)
library(purrr)
#install.packages("corrr")
library(corrr)
library(ggplot2)

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

# - 3.1.a.1 - Domestic Material Consumption (Biomass) - Thousand tonnes (1000T)
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mat_cons_biomass <- read.csv(paste0(cordir_in,"output_data/indicators/3.1.a.1/3.1.a.1.csv"), stringsAsFactors = FALSE)
mat_cons_biomass
names(mat_cons_biomass)
names(mat_cons_biomass)[3] <- "mat_cons_biomass"
names(mat_cons_biomass)[4] <- "unit.mat_cons_biomass"

unique(mat_cons_biomass$geo_code)
options(max.print = 1000 * ncol(mat_cons_biomass))
mat_cons_biomass <- mat_cons_biomass %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

levels(as.factor(mat_cons_biomass$unit.mat_cons_biomass))

# - 3.1.a.2 - Material footprint (Biomass) - Tonne per capita
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mat_footprint_biom <- read.csv(paste0(cordir_in,"output_data/indicators/3.1.a.2/3.1.a.2.csv"), stringsAsFactors = FALSE) 
mat_footprint_biom
names(mat_footprint_biom)
names(mat_footprint_biom)[3] <- "mat_footprint_biom"
names(mat_footprint_biom)[4] <- "unit_mat.footprint.biom"

unique(mat_footprint_biom$geo_code)
# no EU27 nor EU28 in dataset
levels(as.factor(mat_footprint_biom$unit_mat.footprint.biom))

# - 3.1.b.1 - Energy productivity - eur/kg of oil equivalent
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
energy_prod <- read.csv(paste0(cordir_in, "output_data/indicators/3.1.b.1/3.1.b.1.csv"), stringsAsFactors = FALSE) 
str(energy_prod)
names(energy_prod)
names(energy_prod)[3] <- "energy_prod"
names(energy_prod)[4] <- "unit_energy_prod"

unique(energy_prod$geo_code)
options(max.print = 1000 * ncol(energy_prod))
energy_prod           <- energy_prod %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

levels(as.factor(energy_prod$unit_energy_prod))

# - 3.1.b.2 - Share of renewable energy in gross final energy consumption - Percent (%)
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
renew_energy <- read.csv(paste0(cordir_in,"output_data/indicators/3.1.b.2/3.1.b.2.csv"), stringsAsFactors = FALSE)
renew_energy
names(renew_energy)
names(renew_energy)[3] <- "renew_energy"
names(renew_energy)[4] <- "unit.renew_energy"

unique(renew_energy$geo_code)
options(max.print = 1100 * ncol(renew_energy))
renew_energy           <- renew_energy %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

levels(as.factor(renew_energy$unit.renew_energy))

# - 3.1.c.2 - Circular material rate - percent (% of total material use)
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
circ_mat_rate <- read.csv(paste0(cordir_in,"output_data/indicators/3.1.c.2/3.1.c.2.csv"), stringsAsFactors = FALSE)
circ_mat_rate
names(circ_mat_rate)
names(circ_mat_rate)[3] <- "circ_mat_rate"
names(circ_mat_rate)[4] <- "unit.circ_mat_rate"

unique(circ_mat_rate$geo_code)
options(max.print = 1100 * ncol(circ_mat_rate))
circ_mat_rate           <- circ_mat_rate %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

levels(as.factor(circ_mat_rate$unit.circ_mat_rate))

# - 3.4.a.2 - Total biomass consumed for energy - 1000 T of Dry Matter 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
biom_energy <- read.csv(paste0(cordir_in,"output_data/indicators/3.4.a.2/3.4.a.2.csv"), stringsAsFactors = FALSE)
biom_energy
names(biom_energy)
names(biom_energy)[3] <- "biom_energy"
names(biom_energy)[4] <- "unit.biom_energy"

unique(biom_energy$geo_code)
options(max.print = 1100 * ncol(biom_energy))
biom_energy           <- biom_energy %>%
  filter(geo_code != "EU28")

levels(as.factor(biom_energy$unit.biom_energy))

# - 3.4.a.3 - Total biomass consumed for materials - 1000 T of Dry Matter
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
biom_mat <- read.csv(paste0(cordir_in,"output_data/indicators/3.4.a.3/3.4.a.3.csv"), stringsAsFactors = FALSE)
biom_mat
names(biom_mat)
names(biom_mat)[3] <- "biom_mat"
names(biom_mat)[4] <- "unit.biom_mat"

unique(biom_mat$geo_code)
options(max.print = 1100 * ncol(biom_mat))
biom_mat           <- biom_mat %>%
  filter(geo_code != "EU28")

levels(as.factor(biom_mat$unit.biom_mat))

# - 3.4.a.4 - Share of woody biomass used for energy
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
woody_energy <- read.csv(paste0(cordir_in,"output_data/indicators/3.4.a.4/3.4.a.4.csv"), stringsAsFactors = FALSE)
woody_energy
names(woody_energy)
names(woody_energy)[3] <- "woody_energy"
names(woody_energy)[4] <- "unit.woody_energy"

unique(woody_energy$geo_code)
options(max.print = 1100 * ncol(woody_energy))
woody_energy           <- woody_energy %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

levels(as.factor(woody_energy$unit.woody_energy))
woody_energy_4_energy   <- woody_energy %>% filter(unit.woody_energy %in% c("ene"))
woody_energy_4_material <- woody_energy %>% filter(unit.woody_energy %in% c("mat"))

names(woody_energy_4_energy)[3]   <- "woody_energy_4_energy"
names(woody_energy_4_energy)[4]   <- "unit.woody_energy_4_energy"
names(woody_energy_4_material)[3] <- "woody_energy_4_material"
names(woody_energy_4_material)[4] <- "unit.woody_energy_4_material"