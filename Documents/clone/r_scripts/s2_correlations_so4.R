# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# EU strategy objective 4  (so4) - Mitigating and adapting to climate change
# +001 COMPUTE CORRELATIONS
#      CORRELATIONS ARE COMPUTED BETWEEN 2 INDICATORS & FOR 1 YEAR & ALL MEMBER STATES
# This script is linked to s1_in_so4.R
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Create a dataframe containing indicators' data  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
so4_climate <- GHG_agri %>% 
  full_join(GHG_lulucf, by=c("geo_code", "time")) %>%
  full_join(WEI,by=c("geo_code", "time")) %>%
  select(-starts_with('unit'))

names(so4_climate)
so4_climate_long <- so4_climate %>% 
  pivot_longer(GHG_agri:WEI,names_to = 'var')

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate all combinaisons of indicators
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
so4_climate_vars <- unique(so4_climate_long$var)

so4_climate_long_expanded <- expand.grid(var_name1 = so4_climate_vars, var_name2 = so4_climate_vars) %>% 
  left_join(so4_climate_long, by=c("var_name1"="var")) %>% 
  left_join(so4_climate_long, by=c("var_name2"="var","time"="time", "geo_code"="geo_code"))%>%
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
so4_climate_corr <- so4_climate_long_expanded %>% 
  group_by(time, var_name1, var_name2) %>%
  nest() %>%
  mutate(corr=map(data,spearmantestone)) %>%
  unnest(corr) %>%
  select(-data)  

# Create a new column: if the pvalue is < 0.05, R returns TRUE
#  H0 is rejected : rho=/0, there is a correlation
so4_climate_corr$result <- so4_climate_corr$pvalue < 0.05 

# Only keep when there is a correlation
so4_climate_corr_signif  <- so4_climate_corr %>% 
  filter(result== "TRUE")

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Plot the results
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ggplot(data = so4_climate_corr_signif, aes(x = time, y = rho, color= rho)) + 
  geom_point() + 
  facet_grid(var_name1 ~ var_name2) +
  ggtitle("Spearman correlation - EU strategy objective 4") +
  scale_colour_gradient(low = "red", high = "green")

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Save the plot to a pdf - does not work
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
so4_climate_correlationplot <- file.path(cordir_in, "so4_climate_correlationplot.pdf")
ggsave(so4_climate_correlationplot, width=30, height=30, units="cm")