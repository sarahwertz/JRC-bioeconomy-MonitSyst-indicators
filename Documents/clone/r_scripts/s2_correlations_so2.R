# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# EU strategy objective 2  (so2) - Managing Natural Resources Sustainably
# +001 COMPUTE CORRELATIONS
#      CORRELATIONS ARE COMPUTED BETWEEN 2 INDICATORS & FOR 1 YEAR & ALL MEMBER STATES
# This script is linked to s1_in_so2.R
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Create a dataframe containing indicators' data  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate all combinaisons of indicators
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
a_f_vars <- unique(agri_forest_long$var)

a_f_long_expanded <- expand.grid(var_name1 = a_f_vars, var_name2 = a_f_vars) %>% 
  left_join(agri_forest_long, by=c("var_name1"="var")) %>% 
  left_join(agri_forest_long, by=c("var_name2"="var","time"="time", "geo_code"="geo_code"))%>%
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
a_f_corr <- a_f_long_expanded %>% 
  group_by(time, var_name1, var_name2) %>%
  nest() %>%
  mutate(corr=map(data,spearmantestone)) %>%
  unnest(corr) %>%
  select(-data)  

# Create a new column: if the pvalue is < 0.05, R returns TRUE
#  H0 is rejected : rho=/0, there is a correlation
a_f_corr$result <- a_f_corr$pvalue < 0.05 

# Only keep when there is a correlation
a_f_corr_signif  <- a_f_corr %>% 
    filter(result== "TRUE")
    
a_f_corr_signif <- a_f_corr_signif[ !( grepl("intens_farming", a_f_corr_signif$var_name1) &  grepl("intens_farming", a_f_corr_signif$var_name2) ) , ]    

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Plot the results
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ggplot(data = a_f_corr, aes(x = time, y = rho, color= rho)) + 
    geom_point() + 
    facet_grid(var_name1 ~ var_name2) +
    ggtitle("Spearman correlation") +
    scale_colour_gradient(low = "red", high = "green")

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Save the plot to a pdf - does not work
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 if(FALSE){
     # Save the plot to a pdf if you want to
     plotfilename <- file.path(tempdir(), "correlationplot.pdf")
     ggsave(plotfilename, width=30, height=30, units="cm")
     message("plot saved to ", plotfilename)
 }

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