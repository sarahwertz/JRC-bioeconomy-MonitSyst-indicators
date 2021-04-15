# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# EU strategy objective 1  (so1) - Ensuring food and nutrition security
# +001 COMPUTE CORRELATIONS
#      CORRELATIONS ARE COMPUTED BETWEEN 2 INDICATORS & FOR 1 YEAR & ALL MEMBER STATES
# This script is linked to s1_in_so1.R
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Create a dataframe containing indicators' data  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
food_nutri <- awu %>% 
  full_join(biom_food,by=c("geo_code", "time")) %>%
  full_join(calorie_supply_animal,by=c("geo_code", "time")) %>%
  full_join(calorie_supply_vegetal,by=c("geo_code", "time")) %>%
  full_join(food_insecurity,by=c("geo_code", "time")) %>%
  select(-starts_with('unit'))

names(food_nutri)
food_nutri_long <- food_nutri %>% 
  pivot_longer(awu:food.insecurity,names_to = 'var')

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate all combinaisons of indicators
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
food_nutri_vars <- unique(food_nutri_long$var)

food_nutri_long_expanded <- expand.grid(var_name1 = food_nutri_vars, var_name2 = food_nutri_vars) %>% 
  left_join(food_nutri_long, by=c("var_name1"="var")) %>% 
  left_join(food_nutri_long, by=c("var_name2"="var","time"="time", "geo_code"="geo_code"))%>%
  # Remove identical variable names and remove NA values
  filter(var_name1 != var_name2 & !is.na(value.x) & !is.na(value.y))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Create a function to compute the correlation between variables from 2 columns
# Try catch statement copied from https://stackoverflow.com/questions/12193779/how-to-write-trycatch-in-r
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Compute the correlation
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
food_nutri_corr <- food_nutri_long_expanded %>% 
  group_by(time, var_name1, var_name2) %>%
  nest() %>%
  mutate(corr=map(data,spearmantestone)) %>%
  unnest(corr) %>%
  select(-data)  

# Create a new column: if the pvalue is < 0.05, R returns TRUE
#  H0 is rejected : rho=/0, there is a correlation
food_nutri_corr$result <- food_nutri_corr$pvalue < 0.05 

# Only keep when there is a correlation
food_nutri_corr_signif  <- food_nutri_corr %>% 
  filter(result== "TRUE")

food_nutri_corr_signif <- food_nutri_corr_signif[ !( grepl("calorie_supply", food_nutri_corr_signif$var_name1) &  grepl("calorie_supply", food_nutri_corr_signif$var_name2) ) , ]    

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Plot the results
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ggplot(data = a_f_corr, aes(x = time, y = rho, color= rho)) + 
  geom_point() + 
  facet_grid(var_name1 ~ var_name2) +
  ggtitle("Spearman correlation") +
  scale_colour_gradient(low = "red", high = "green")

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Plot indicators' temporal series -> should it be done for only some countries??
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
plot_food_nutri_countries <- ggplot(food_nutri_long, aes(time,value)) +
  geom_point() +
  theme(legend.position = "none") +
  facet_wrap(geo_code~var, scales = 'free', nrow=28, ncol=5) +
  ylab("")

# Save the plot to a pdf 
plot_food_nutri_countries <- file.path(cordir_in, "food_nutri_correlationplot.pdf")
ggsave(plot_food_nutri_countries, width=500, height=500, units="cm", limitsize = FALSE)
message("plot saved to ", plot_food_nutri_countries)
