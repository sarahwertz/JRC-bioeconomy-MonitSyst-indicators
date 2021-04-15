# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++1 SET WORKING ENVIRONMENT
# +++2 CREATING OBJECTS ON R
# +++3 CREATING FOLDERS ON THE COMPUTER
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

## +++2 CREATING OUTPUT FOLDER IN R
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#cordir        <- paste0(workdir,"JRC-BioeconomyUnit/Trade-offs_synergies/Test-correlation/")
#cordir_in     <- paste0(cordir,"indicators")
#
## +++3 CREATING FOLDERS ON THE COMPUTER
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#dir.create(cordir,showWarnings = F)
