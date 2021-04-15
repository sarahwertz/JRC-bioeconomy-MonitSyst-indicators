# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++0 SET WORKING ENVIRONMENT
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## +++1 SET WORKING ENVIRONMENT 
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#install.packages("here")
library(here)
cordir_in <- here()

#For me
cordir_in <- ("~/biomon-data")
setwd(cordir_in)
cordir_in <- paste0(getwd(),"/")

# Load configuration variables
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library(dplyr)
library(tidyr)
library(purrr)
#install.packages("corrr")
library(corrr)
library(ggplot2)