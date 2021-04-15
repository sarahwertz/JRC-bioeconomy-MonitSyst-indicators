# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 COMPUTE CORRELATIONS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# CREATE A DATAFRAME CONTAINING: 1 COLUMN=COUTRIES; 1 COLUMN=YEARS; COLUMNS CONTAINING INDICATORS' VALUES AND UNITS
# COMPUTE CORRELATIONS
#      -> CORRELATIONS ARE COMPUTED BETWEEN 2 VARIABLES & FOR 1 YEAR & TAKING INTO ACCOUNT INDICATORS' VARIATIONS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Create a dataframe containing arranged indicators' data  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
agri_forest <- roundwood %>% 
  full_join(intens_farming_high,by=c("geo_code", "time")) %>%
  full_join(intens_farming_medium,by=c("geo_code", "time")) %>%
  full_join(intens_farming_low,by=c("geo_code", "time")) %>%
  full_join(NAI,by=c("geo_code", "time")) %>%
  full_join(organic_farming,by=c("geo_code", "time")) %>% 
  select(-starts_with('unit'))

names(agri_forest)
agri_forest_long <- agri_forest %>% 
  pivot_longer(roundwood.removals:organic_farming,names_to = 'var')

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate all combinaisons of indicators
# Second function

# test expand.grid
# a_f_long_expanded_test <- expand.grid(agri_forest_long$var,agri_forest_long$var) %>% 
#   left_join(agri_forest_long, by=c("Var1"="var")) %>% 
#   left_join(agri_forest_long, by=c("var_name2"="var","time"="time", "geo_code"="geo_code"))

a_f_vars <- unique(agri_forest_long$var)

a_f_long_expanded <- expand.grid(var_name1 = a_f_vars, var_name2 = a_f_vars) %>% 
  left_join(agri_forest_long, by=c("var_name1"="var")) %>% 
  left_join(agri_forest_long, by=c("var_name2"="var","time"="time", "geo_code"="geo_code"))%>%
  # Remove identical variable names and remove NA values
  filter(var_name1 != var_name2 & !is.na(value.x) & !is.na(value.y))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Create a function to compute the correlation between variables from 2 columns
# Try catch statement copied from https://stackoverflow.com/questions/12193779/how-to-write-trycatch-in-r

#'@param df data frame containing the country code in the first column 
#' and numeric variables in columns 2 and 3
spearmantestone <- function(df){
  out <- tryCatch(
    {
      results <- cor.test(df[[2]],df[[3]],
                          method = "spearman",
                          exact = FALSE) 
      tibble(corr=results$statistic, pvalue=results$p.value, rho=results$estimate,message = "ok")
    },
    error=function(cond) {
      message("Data issue first vector:", df[[2]])
      message("Data issue second vector:", df[[3]])
      message("Here's the original error message:")
      message(cond)
      # Choose a return value in case of error
      return(tibble(corr = NA, pvalue = NA, message = as.character(cond)))
    },
    warning=function(cond) {
      message("Data issue:", df[[2]],df[[3]])
      message("Here's the original warning message:")
      message(cond)
      # Choose a return value in case of warning
      return(tibble(corr = NA, pvalue = NA, message = as.character(cond)))
    }
  )    
  return(out)
}
a_f_corr <- a_f_long_expanded %>% 
  group_by(time, var_name1, var_name2) %>%
  nest() %>%
  mutate(corr=map(data,spearmantestone)) %>%
  unnest(corr) %>%
  select(-data)  

# Create a new column: if the pvalue is < 0.05, R returns TRUE, there is a correlation
# If returns FALSE, H0 is not rejected : rho=0, there is no correlation
a_f_corr$result <- a_f_corr$pvalue < 0.05 

# Only keep when there is a correlation
a_f_corr_signif  <- a_f_corr %>% 
  filter(result== "TRUE")

a_f_corr_signif <- a_f_corr_signif[ !( grepl("intens_farming", a_f_corr_signif$var_name1) &  grepl("intens_farming", a_f_corr_signif$var_name2) ) , ]    

ggplot(data = a_f_corr, aes(x = time, y = rho, color= rho)) + 
  geom_point() + 
  facet_grid(var_name1 ~ var_name2) +
  ggtitle("Spearman correlation") +
  scale_colour_gradient(low = "red", high = "green")

# Does not work. Do not know why.
if(FALSE){
  # Save the plot to a pdf if you want to
  a_f_corr_plot <- file.path(cordir_in(), "a_f_correlationplot.pdf")
  ggsave(a_f_corr_plot, width=30, height=30, units="cm")
  message("plot saved to ", a_f_corr_plot)
}

# if(FALSE){
#     # Save the plot to a pdf if you want to
#     plotfilename <- file.path(tempdir(), "correlationplot.pdf")
#     ggsave(plotfilename, width=30, height=30, units="cm")
#     message("plot saved to ", plotfilename)
# }

# # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# # test to compute the correlation for a given year
# agri_forest_2017 <- agri_forest %>% filter(time==2017) 
# cor_2017 <- cor.test(agri_forest_2017$roundwood.removals, agri_forest_2017$intens_farming_high,
#                      method = "spearman",
#                      exact=FALSE) 
# plot(agri_forest_2017$roundwood.removals, agri_forest_2017$intens_farming_high)
# 
# # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# # choose a year for which there is a higher probability to have a correlation
# agri_forest_2010 <- agri_forest %>% filter(time==2010) 
# cor_2010 <- cor.test(agri_forest_2010$roundwood.removals, agri_forest_2010$felling.rates,
#                      method = "spearman",
#                      exact=FALSE) 
# plot(agri_forest_2010$roundwood.removals, agri_forest_2010$felling.rates)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# # Check if the function works for a given year
# 
# agri_forest_2010 %>% 
#   select(geo_code,roundwood.removals,felling.rates) %>% 
#   spearmantestone()
# 
# agri_forest_2010 %>% 
#   select(geo_code,roundwood.removals,organic_farming) %>% 
#   spearmantestone()
# 
# # Compute correlation for all time periods 
# # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# names(agri_forest)
# model_vars <- c("roundwood.removals", "intens_farming_high", "intens_farming_medium", "intens_farming_low", "felling.rates", "organic_farming")
# 
# agri_forest_corr_year <- agri_forest %>% 
#                          group_by(time) %>% 
#                          select(model_vars) %>%
#                          nest() %>%
#                          mutate(corr = map(data, correlate, 
#                                            use= "pairwise.complete.obs", 
#                                            method = "spearman", 
#                                            quiet=TRUE))%>%
#                          unnest(corr) %>%
#                          select(-data)
# 
# # visualisations
# # getting a graph illustrating variation of correlation coefficients between many variables
# # Change to long format. Arrange variables with Y first then the X variables.
# # Create a grid plot.
# # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 
# #lmodel_vars <- paste0("l", model_vars)
# 
# agri_forest_corr_year_graph <- agri_forest_corr_year %>% 
#                                pivot_longer(model_vars) %>%
#                                arrange(desc(term), desc(name)) %>%
#                                mutate(term = forcats::as_factor(term),
#                                name = forcats::as_factor(name)) %>%
#                                ggplot(aes(x = time, y = value, color=value)) +
#                                geom_point() +
#                                facet_grid(term~name) +
#                                ylab("Pearson correlation between the variables in rows and columns") +
#                                scale_color_gradient2()                                              
# agri_forest_corr_year_graph

# Significance of the correlation coefficient - or computation of rho 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#library(stats)
#agri_forest_corr_year_test <- agri_forest %>% 
#  group_by(time) %>% 
#  select(model_vars) %>%
#  nest() %>%
#  mutate(corr = map(data, cor.test))%>%
#  unnest(corr) %>%
#  select(-data)


#filter(!is.na(intens_farming_high) & !is.na(intens_farming_medium) & !is.na(intens_farming_low) & !is.na(felling.rates) & !is.na(roundwood.removals) & !is.na(organic_farming))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 2010
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Select 2010 and remove the NA values in the column of the indicators' values
# agri_forest_2010 <- agri_forest %>% 
#   filter(time == 2010 & !is.na(intens_farming_high) & !is.na(intens_farming_medium) & !is.na(intens_farming_low) & !is.na(felling.rates))
# 
# # Compute correlation for 2010 and high intensity
# # test for 2 indicators
# # cor(agri_forest_2010$roundwood.removals.x,agri_forest_2010$intens_farming)
# 
# # for all indicators
# # rearrange the dataframe
# names(agri_forest_2010)
# agri_forest_2010 <- agri_forest_2010[,-c(2,4,6,8,10,12,14)] 
# 
# # correlation
# # cor(agri_forest_2010)
# # Error in cor(agri_forest_2010) : 'x' must be numeric
# cor(agri_forest_2010[sapply(agri_forest_2010, is.numeric)])
# # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
