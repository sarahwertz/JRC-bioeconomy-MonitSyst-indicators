# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 Visualize results
# & Export 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library(gridExtra)

agri_forest_results_Na <- agri_forest_corr_year %>% 
                       pivot_longer(model_vars)

agri_forest_results <- agri_forest_results_Na %>% filter(!is.na(value))

# felling rates X roundwood removals
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_felling_roundwood   <- agri_forest_results %>% filter(term %in% c("felling.rates") & name %in% c("roundwood.removals"))
grid.table(t_felling_roundwood)

# felling rates X intens_farming_high
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_felling_intens_farm_high   <- agri_forest_results %>% filter(term %in% c("felling.rates") & name %in% c("intens_farming_high"))
grid.table(t_felling_intens_farm_high)

# felling rates X intens_farming_medium
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_felling_intens_farm_med   <- agri_forest_results %>% filter(term %in% c("felling.rates") & name %in% c("intens_farming_medium"))
grid.table(t_felling_intens_farm_med)

# felling rates X intens_farming_low
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_felling_intens_farm_low   <- agri_forest_results %>% filter(term %in% c("felling.rates") & name %in% c("intens_farming_low"))
grid.table(t_felling_intens_farm_low)

# felling rates X organic_farming
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_felling_organic_farming   <- agri_forest_results %>% filter(term %in% c("felling.rates") & name %in% c("organic_farming"))
grid.table(t_felling_organic_farming)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# intens_farming_high X intens_farming_low
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_intens_farm_high_low   <- agri_forest_results %>% filter(term %in% c("intens_farming_high") & name %in% c("intens_farming_low"))
grid.table(t_intens_farm_high_low)

# intens_farming_high X intens_farming_medium
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_intens_farm_high_medium   <- agri_forest_results %>% filter(term %in% c("intens_farming_high") & name %in% c("intens_farming_medium"))
grid.table(t_intens_farm_high_medium)

# intens_farming_high X organic_farming
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_intens_farm_high_organic  <- agri_forest_results %>% filter(term %in% c("intens_farming_high") & name %in% c("organic_farming"))
grid.table(t_intens_farm_high_organic)

# intens_farming_high X roundwood removals
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_intens_farm_high_roundwood  <- agri_forest_results %>% filter(term %in% c("intens_farming_high") & name %in% c("roundwood.removals"))
grid.table(t_intens_farm_high_roundwood)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# intens_farming_low X organic_farming
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_intens_farm_low_organic  <- agri_forest_results %>% filter(term %in% c("intens_farming_low") & name %in% c("organic_farming"))
grid.table(t_intens_farm_low_organic)

# intens_farming_low X intens_farming_medium
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_intens_farm_low_medium  <- agri_forest_results %>% filter(term %in% c("intens_farming_low") & name %in% c("intens_farming_medium"))
grid.table(t_intens_farm_low_medium)

# intens_farming_low X roundwood.removals
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_intens_farm_low_roundwood  <- agri_forest_results %>% filter(term %in% c("intens_farming_low") & name %in% c("roundwood.removals"))
grid.table(t_intens_farm_low_roundwood)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# intens_farming_medium X organic_farming
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_intens_farm_medium_organic  <- agri_forest_results %>% filter(term %in% c("intens_farming_medium") & name %in% c("organic_farming"))
grid.table(t_intens_farm_medium_organic)

# intens_farming_medium X roundwood.removals
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_intens_farm_medium_roundwood  <- agri_forest_results %>% filter(term %in% c("intens_farming_medium") & name %in% c("roundwood.removals"))
grid.table(t_intens_farm_medium_roundwood)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# organic_farming X roundwood.removals
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
levels(as.factor(agri_forest_results$term))
levels(as.factor(agri_forest_results$name))
t_organic_farm_roundwood <- agri_forest_results %>% filter(term %in% c("organic_farming") & name %in% c("roundwood.removals"))
grid.table(t_organic_farm_roundwood)
