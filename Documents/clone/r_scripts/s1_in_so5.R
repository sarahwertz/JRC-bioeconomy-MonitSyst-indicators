# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# EU strategy objective 5  (so5) - Strengthening European Competitiveness and Creating Jobs
# +001 DOWNLOAD DATA
# +002 PREPARE & READ  DATA
#      5.1.a.2 - Value-added per sector/Bioeconomy value added   
#      5.1.a.5 - Gross value added per person employed in bioeconomy
#      5.1.b.1 - Turnover in bioeconomy per sector 
#      5.1.b.2 - Value-added per sector
#      5.2.a.1 - Persons employed per bioeconomy sectors
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

# - 5.1.a.2 - Value-added per sector/Bioeconomy value added 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
value_add_sect_bioecon <- read.csv(paste0(cordir_in,"output_data/indicators/5.1.a.2/5.1.a.2.csv"), stringsAsFactors = FALSE)
value_add_sect_bioecon
names(value_add_sect_bioecon)
names(value_add_sect_bioecon)[3] <- "value_add_sect_bioecon"
names(value_add_sect_bioecon)[4] <- "unit.value_add_sect_bioecon"

unique(value_add_sect_bioecon$geo_code)
options(max.print = 1000 * ncol(value_add_sect_bioecon))
value_add_sect_bioecon <- value_add_sect_bioecon %>%
  filter(geo_code != "EU27_2020") %>% 
  filter(geo_code != "EU28")

levels(as.factor(value_add_sect_bioecon$unit.value_add_sect_bioecon))

# - 5.1.a.5 - Gross value added per person employed in bioeconomy
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mat_footprint_biom <- read.csv(paste0(cordir_in,"output_data/indicators/3.1.a.2/3.1.a.2.csv"), stringsAsFactors = FALSE) 
mat_footprint_biom
names(mat_footprint_biom)
names(mat_footprint_biom)[3] <- "mat_footprint_biom"
names(mat_footprint_biom)[4] <- "unit_mat.footprint.biom"

unique(mat_footprint_biom$geo_code)
# no EU27 nor EU28 in dataset
levels(as.factor(mat_footprint_biom$unit_mat.footprint.biom))

# - 5.1.b.1 - Turnover in bioeconomy per sector
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

# - 5.1.b.2 - Value-added per sector
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

# - 5.2.a.1 - Persons employed per bioeconomy sectors
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