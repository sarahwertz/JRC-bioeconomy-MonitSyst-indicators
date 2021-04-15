# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 DOWNLOAD READ PREPARE DATA
# EU strategy objective 2  (so2) - Managing Natural Resources Sustainably
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Load configuration variables
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
source("s0_setworking.R") 

library(dplyr)
library(tidyr)
library(purrr)
#install.packages("corrr")
library(corrr)
library(ggplot2)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 DOWNLOAD DATA
#BitBucket repository : Bioeconomy Knowledge Centre / biomon-data
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#clone repository
#on the command prompt:
#git clone https://citnet.tech.ec.europa.eu/CITnet/stash/scm/beo/biomon-data.git
#cd folder-in-which-you-download-data
#git checkout --track origin/develop

# ++++ PREPARE DATA
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# - 2.1.b.4 - Share of organic farming in UAA  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
organic_farming <- read.csv(paste0(cordir_in,"/2.1.b.4/2.1.b.4.csv"), stringsAsFactors = FALSE)
organic_farming
names(organic_farming)
names(organic_farming)[3] <- "organic_farming"
names(organic_farming)[4] <- "unit.organic"

unique(organic_farming$geo_code)
options(max.print = 1000 * ncol(organic_farming))
organic_farming <- organic_farming %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

# - 2.2.a.1 - Long term ratio of annual fellings to net annual increment 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
NAI <- read.csv(paste0(cordir_in,"/2.2.a.1/2.2.a.1.csv"), stringsAsFactors = FALSE) 
NAI
names(NAI)
names(NAI)[3] <- "felling.rates"
names(NAI)[4] <- "unit_felling.rates"

unique(NAI$geo_code)
#If the dataframe is not taken entirely, R needs to be forced to read further
options(max.print = 1000 * ncol(NAI))
NAI           <- NAI %>%
  filter(geo_code != "EU28")

# - 2.3.a.2 - Roundwood removals 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
roundwood <- read.csv(paste0(cordir_in, "/2.3.a.2/2.3.a.2.csv"), stringsAsFactors = FALSE) 
str(roundwood)
names(roundwood)
names(roundwood)[3] <- "roundwood.removals"
names(roundwood)[4] <- "unit_m3.volume.ob"
names(roundwood)

unique(roundwood$geo_code)
options(max.print = 1000 * ncol(roundwood))
roundwood           <- roundwood %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

# - 2.2.d.5 - Intensification of farming (high, medium, low) 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
intens_farming <- read.csv(paste0(cordir_in,"/2.2.d.5/2.2.d.5.csv"), stringsAsFactors = FALSE)
intens_farming
names(intens_farming)
names(intens_farming)[3] <- "intens_farming"
names(intens_farming)[4] <- "unit.intensity"

unique(intens_farming$geo_code)
options(max.print = 1100 * ncol(intens_farming))
intens_farming           <- intens_farming %>%
  filter(geo_code != "EU27_2020") %>% filter(geo_code != "EU28")

levels(as.factor(intens_farming$unit.intensity))
intens_farming_high   <- intens_farming %>% filter(unit.intensity %in% c("HIGH_INP"))
intens_farming_medium <- intens_farming %>% filter(unit.intensity %in% c("MED_INP"))
intens_farming_low    <- intens_farming %>% filter(unit.intensity %in% c("LOW_INP"))

names(intens_farming_high)[3]   <- "intens_farming_high"
names(intens_farming_high)[4]   <- "unit.intensity.high"
names(intens_farming_medium)[3] <- "intens_farming_medium"
names(intens_farming_medium)[4] <- "unit.intensity.medium"
names(intens_farming_low)[3]    <- "intens_farming_low"
names(intens_farming_low)[4]    <- "unit.intensity.low"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Compare available data for countries : if countries are missing and their order
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# anti_join(organic_farming,NAI, by="geo_code")
# anti_join(NAI,organic_farming,by="geo_code")
# anti_join(roundwood,NAI, by="geo_code")
# anti_join(NAI,roundwood,by="geo_code")
# anti_join(NAI,intens_farming,by="geo_code")
# anti_join(intens_farming,NAI,by="geo_code")
# 
# anti_join(organic_farming,NAI, by="time")
# anti_join(NAI,organic_farming,by="time")
# anti_join(roundwood,NAI, by="time")
# anti_join(NAI,roundwood,by="time")
# anti_join(NAI,intens_farming,by="time")
# anti_join(intens_farming,NAI,by="time")
