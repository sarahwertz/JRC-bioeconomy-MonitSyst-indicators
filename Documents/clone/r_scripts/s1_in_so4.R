# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# EU strategy objective 4  (so4) - Mitigating and adapting to climate change
# +001 DOWNLOAD DATA
# +002 PREPARE & READ  DATA
#      4.1.a.3 - Net GHG emissions (emissions and removals) from agriculture  
#      4.1.a.6 - Net GHG emissions (emissions and removals) from LULUCF
#      4.1.b.3 - Water exploitation index (WEI) 
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

# - 4.1.a.3 - Net GHG emissions (emissions and removals) from agriculture  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
GHG_agri <- read.csv(paste0(cordir_in,"output_data/indicators/4.1.a.3/4.1.a.3.csv"), stringsAsFactors = FALSE)
GHG_agri
names(GHG_agri)
names(GHG_agri)[3] <- "GHG_agri"
names(GHG_agri)[4] <- "unit_GHG_agri"

unique(GHG_agri$geo_code)
#If the dataframe is not taken entirely, R needs to be forced to read further
options(max.print = 1000 * ncol(GHG_agri))
GHG_agri <- GHG_agri %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

levels(as.factor(GHG_agri$unit.GHG_agri))

# - 4.1.a.6 - Net GHG emissions (emissions and removals) from LULUCF  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
GHG_lulucf <- read.csv(paste0(cordir_in,"output_data/indicators/4.1.a.6/4.1.a.6.csv"), stringsAsFactors = FALSE) 
GHG_lulucf
names(GHG_lulucf)
names(GHG_lulucf)[3] <- "GHG_lulucf"
names(GHG_lulucf)[4] <- "unit_GHG_lulucf"

unique(GHG_lulucf$geo_code)
options(max.print = 1000 * ncol(GHG_lulucf))
GHG_lulucf           <- GHG_lulucf %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

levels(as.factor(GHG_lulucf$unit_GHG_lulucf))

# - 4.1.b.3 - Water exploitation index (WEI) 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
WEI <- read.csv(paste0(cordir_in, "output_data/indicators/4.1.b.3/4.1.b.3.csv"), stringsAsFactors = FALSE) 
str(WEI)
names(WEI)
names(WEI)[3] <- "WEI"
names(WEI)[4] <- "unit_WEI"

unique(WEI$geo_code)
options(max.print = 1000 * ncol(WEI))
WEI           <- WEI %>%
  filter(geo_code != "EU27_2020")

levels(as.factor(WEI$unit_WEI))