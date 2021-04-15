# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# EU strategy objective 3  (so3) - Reducing dependance on non-renewable unsustainable sources
# whether sourced domestically or from abroad
# +001 COMPUTE CORRELATIONS
#      CORRELATIONS ARE COMPUTED BETWEEN 2 INDICATORS & FOR 1 YEAR & ALL MEMBER STATES
# This script is linked to s1_in_so3.R
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Create a dataframe containing indicators' data  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sust_sources <- biom_energy %>% 
  full_join(biom_mat,by=c("geo_code", "time")) %>%
  full_join(circ_mat_rate,by=c("geo_code", "time")) %>%
  full_join(energy_prod,by=c("geo_code", "time")) %>%
  full_join(mat_cons_biomass,by=c("geo_code", "time")) %>%
  full_join(mat_footprint_biom,by=c("geo_code", "time")) %>% 
  full_join(renew_energy,by=c("geo_code", "time")) %>% 
  full_join(woody_energy_4_energy,by=c("geo_code", "time")) %>% 
  full_join(woody_energy_4_material,by=c("geo_code", "time")) %>% 
  select(-starts_with('unit'))

names(sust_sources)
sust_sources_long <- sust_sources %>% 
  pivot_longer(biom_energy:woody_energy_4_material,names_to = 'var')

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate all combinaisons of indicators
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sust_sources_vars <- unique(sust_sources_long$var)

sust_sources_long_expanded <- expand.grid(var_name1 = sust_sources_vars, var_name2 = sust_sources_vars) %>% 
  left_join(sust_sources_long, by=c("var_name1"="var")) %>% 
  left_join(sust_sources_long, by=c("var_name2"="var","time"="time", "geo_code"="geo_code"))%>%
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
sust_sources_corr <- sust_sources_long_expanded %>% 
  group_by(time, var_name1, var_name2) %>%
  nest() %>%
  mutate(corr=map(data,spearmantestone)) %>%
  unnest(corr) %>%
  select(-data)  

# Create a new column: if the pvalue is < 0.05, R returns TRUE
#  H0 is rejected : rho=/0, there is a correlation
sust_sources_corr$result <- sust_sources_corr$pvalue < 0.05 

# Only keep when there is a correlation
sust_sources_corr_signif  <- sust_sources_corr %>% 
  filter(result== "TRUE")

sust_sources_corr_signif <- sust_sources_corr_signif[ !( grepl("woody_energy", sust_sources_corr_signif$var_name1) &  grepl("woody_energy", sust_sources_corr_signif$var_name2) ) , ]    

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Plot the results
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
plot_sust_sources_corr <- ggplot(data = sust_sources_corr_signif, aes(x = time, y = rho, color= rho)) + 
  geom_point() + 
  facet_grid(var_name1 ~ var_name2) +
  ggtitle("Spearman correlation - EU strategy objective 3") +
  scale_colour_gradient(low = "red", high = "green")

# To PDF 
plot_sust_sources_corr <- file.path(cordir_in, "sust_sources_correlationplot.pdf")
ggsave(plot_sust_sources_corr, width=40, height=40, units="cm", limitsize = FALSE)
message("plot saved to ", plot_food_nutri_countries)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Save the plot to a pdf 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
plotfilename <- file.path(tempdir(), "correlationplot.pdf")
ggsave(plotfilename, width=30, height=30, units="cm")
message("plot saved to ", plotfilename)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Plot indicators' temporal series for some countries
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# geo_code_select <- select(agri_forest_long,geo_code==AT:DK)
# geo_code_select <- agri_forest_long[agri_forest_long$geo_code=="AT","DK"]

plot_a_f_countries <- ggplot(agri_forest_long, aes(time,value)) +
  geom_point() +
  theme(legend.position = "none") +
  facet_wrap(geo_code~var, scales = 'free', nrow=28, ncol=6) +
  ylab("")