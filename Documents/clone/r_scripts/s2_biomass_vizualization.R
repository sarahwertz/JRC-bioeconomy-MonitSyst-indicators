# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Linked to the previous script "s1_in_biomass.R" 
# +001 SCATTER PLOTS
# Inspect data before trying to interpret with statistics
#      For 2011 and 2015
#       3.4.a.2 - 3.4.a.3: Total biomass consumed for energy and materials  - 1000T dry matter/capita
#       3.4.a.2 - 3.1.c.2: Total biomass consumed for energy and circular material rate 
#       3.1.a.1 - 3.4.a.2: Domestic material consumption (Biomass) and Total biomass consumed for energy (Net trade) 
#       3.1.b.2 - 3.4.a.2: Share of renewable energy in gross final energy consumption and Total biomass consumed for energy (Net trade) 
#       3.1.c.2 - 3.4.a.3: Circular material rate and Total biomass consumed for materials 
#       3.1.a.1 - 3.4.a.3: Domestic material consumption (biomass) and Total biomass consumed for materials 
#       3.1.a.2 - 3.4.a.3: Material footprint (biomass) and Total biomass consumed for materials 
#       3.1.a.1 - 3.1.c.2: Domestic Material Consumption (biomass) and Circular material rate 
#       3.1.a.2 - 3.1.c.2: Material footprint (biomass) and Circular material rate 
#       3.1.a.1 - 3.1.b.1: Domestic Material Consumption (biomass) and Energy productivity 
#       3.1.a.2 - 3.1.b.1: Material footprint (biomass) and Energy productivity 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

sust_sources_unit <- biom_energy %>% 
  full_join(biom_mat,by=c("geo_code", "time")) %>%
  full_join(circ_mat_rate,by=c("geo_code", "time")) %>%
  full_join(energy_prod,by=c("geo_code", "time")) %>%
  full_join(mat_cons_biomass,by=c("geo_code", "time")) %>%
  full_join(mat_footprint_biom,by=c("geo_code", "time")) %>% 
  full_join(renew_energy,by=c("geo_code", "time")) %>%
  full_join(tot_biomass,by=c("geo_code", "time")) 
  
#  %>% full_join(woody_energy_4_energy,by=c("geo_code", "time")) %>% 
#  full_join(woody_energy_4_material,by=c("geo_code", "time"))
#  select(-starts_with('unit')) we do not delete it since we are interested in the units for the graphs

#Total biomass consumed for energy (3.4.a.2) and materials (3.4.a.3) - 1000T dry matter/capita
#2011
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
biom_energy_mat2011 <- sust_sources_unit  %>% 
  select(geo_code:biom_mat_capita)
biom_energy_mat2011 <- biom_energy_mat2011[biom_energy_mat2011[, "time"] == 2011,] 
#Order() might be useless actually... Since we just plot the values of the 2 columns, independently from countries
biom_energy_mat2011 <- biom_energy_mat2011[order(biom_energy_mat2011$geo_code),]
biom_energy_mat2011 <- biom_energy_mat2011[ -c(3:6, 8:11) ]

plot(x=biom_energy_mat2011$biom_mat_capita, y=biom_energy_mat2011$biom_energy_capita,xlab="Total biomass consumed for materials (1000T dry matter/capita*100) in 2011",ylab="Total biomass consumed for energy (1000T dry matter/capita*100) in 2011")
text(x=biom_energy_mat2011$biom_mat_capita, y=biom_energy_mat2011$biom_energy_capita,labels=biom_energy_mat2011$geo_code, cex= 0.7, pos=3)

plot(x=biom_energy_mat2011$biom_energy_capita, y=biom_energy_mat2011$biom_mat_capita,xlab="Total biomass consumed for energy (1000T dry matter/capita*100) in 2011",ylab="Total biomass consumed for materials (1000T dry matter/capita*100) in 2011")
text(x=biom_energy_mat2011$biom_energy_capita, y=biom_energy_mat2011$biom_mat_capita,labels=biom_energy_mat2011$geo_code, cex= 0.7, pos=3)

#2015
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
biom_energy_mat2015 <- sust_sources_unit  %>% 
  select(geo_code:biom_mat_capita)
biom_energy_mat2015 <- biom_energy_mat2015[biom_energy_mat2015[, "time"] == 2015,] 
biom_energy_mat2015 <- biom_energy_mat2015[order(biom_energy_mat2015$geo_code),]

biom_energy_mat2015 <- biom_energy_mat2015[ -c(3:6, 8:11) ]

plot(x=biom_energy_mat2015$biom_mat_capita, y=biom_energy_mat2015$biom_energy_capita,xlab="Total biomass consumed for materials (1000T dry matter/capita*100) in 2015",ylab="Total biomass consumed for energy (1000T dry matter/capita*100) in 2015")
text(x=biom_energy_mat2015$biom_mat_capita, y=biom_energy_mat2015$biom_energy_capita,labels=biom_energy_mat2015$geo_code, cex= 0.7, pos=3)

plot(x=biom_energy_mat2015$biom_energy_capita, y=biom_energy_mat2015$biom_mat_capita,xlab="Total biomass consumed for energy (1000T dry matter/capita*100) in 2015",ylab="Total biomass consumed for materials (1000T dry matter/capita*100) in 2015")
text(x=biom_energy_mat2015$biom_energy_capita, y=biom_energy_mat2015$biom_mat_capita,labels=biom_energy_mat2015$geo_code, cex= 0.7, pos=3)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Total biomass consumed for energy (3.4.a.2) and circular material rate (3.1.c.2)
#2011
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
biom_energy_circ2011 <- sust_sources_unit  %>% 
  select(geo_code:biom_energy_capita,circ_mat_rate)
biom_energy_circ2011 <- biom_energy_circ2011[biom_energy_circ2011[, "time"] == 2011,] 
biom_energy_circ2011 <- biom_energy_circ2011[order(biom_energy_circ2011$geo_code),]

biom_energy_circ2011 <- biom_energy_circ2011[ -c(3:6)]

plot(x=biom_energy_circ2011$circ_mat_rate, y=biom_energy_circ2011$biom_energy_capita,xlab="Circular material rate (% of total material use) in 2011",ylab="Total biomass consumed for energy (1000T dry matter/capita*100) in 2011")
text(x=biom_energy_circ2011$circ_mat_rate, y=biom_energy_circ2011$biom_energy_capita,labels=biom_energy_circ2011$geo_code, cex= 0.7, pos=3)

plot(x=biom_energy_circ2011$biom_energy_capita, y=biom_energy_circ2011$circ_mat_rate,xlab="Total biomass consumed for energy (1000T dry matter/capita*100) in 2011",ylab="Circular material rate (% of total material use) in 2011")
text(x=biom_energy_circ2011$biom_energy_capita, y=biom_energy_circ2011$circ_mat_rate,labels=biom_energy_circ2011$geo_code, cex= 0.7, pos=3)

#2015
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
biom_energy_circ2015 <- sust_sources_unit  %>% 
  select(geo_code:biom_energy_capita,circ_mat_rate)
biom_energy_circ2015 <- biom_energy_circ2015[biom_energy_circ2015[, "time"] == 2015,] 
biom_energy_circ2015 <- biom_energy_circ2015[order(biom_energy_circ2015$geo_code),]

biom_energy_circ2015 <- biom_energy_circ2015[ -c(3:6)]

plot(x=biom_energy_circ2015$circ_mat_rate, y=biom_energy_circ2015$biom_energy_capita,xlab="Circular material rate (% of total material use) in 2015",ylab="Total biomass consumed for energy (1000T dry matter/capita*100) in 2015")
text(x=biom_energy_circ2015$circ_mat_rate, y=biom_energy_circ2015$biom_energy_capita,labels=biom_energy_circ2015$geo_code, cex= 0.7, pos=3)

plot(x=biom_energy_circ2015$biom_energy_capita, y=biom_energy_circ2015$circ_mat_rate,xlab="Total biomass consumed for energy (1000T dry matter/capita*100) in 2015",ylab="Circular material rate (% of total material use) in 2015")
text(x=biom_energy_circ2015$biom_energy_capita, y=biom_energy_circ2015$circ_mat_rate,labels=biom_energy_circ2015$geo_code, cex= 0.7, pos=3)

#Domestic material consumption (Biomass) (3.1.a.1) and Total biomass consumed for energy (Net trade) (3.4.a.2)
#2011
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dom_mat_biom_energy2011 <- sust_sources_unit  %>% 
  select(geo_code:biom_energy_capita,mat_cons_biomass_capita)
dom_mat_biom_energy2011 <- dom_mat_biom_energy2011[dom_mat_biom_energy2011[, "time"] == 2011,] 
dom_mat_biom_energy2011 <- dom_mat_biom_energy2011[order(dom_mat_biom_energy2011$geo_code),]

dom_mat_biom_energy2011 <- dom_mat_biom_energy2011[!duplicated(dom_mat_biom_energy2011),]
dom_mat_biom_energy2011 <- dom_mat_biom_energy2011[ -c(3:6)]

plot(x=dom_mat_biom_energy2011$mat_cons_biomass_capita, y=dom_mat_biom_energy2011$biom_energy_capita,xlab="Domestic material consumption (Biomass) (1000T/capita*100) in 2011",ylab="Total biomass consumed for energy (1000T dry matter/capita*100) in 2011")
text(x=dom_mat_biom_energy2011$mat_cons_biomass_capita, y=dom_mat_biom_energy2011$biom_energy_capita,labels=dom_mat_biom_energy2011$geo_code, cex= 0.7, pos=3)

plot(x=dom_mat_biom_energy2011$biom_energy_capita, y=dom_mat_biom_energy2011$mat_cons_biomass_capita,xlab="Total biomass consumed for energy (1000T dry matter/capita*100) in 2011",ylab="Domestic material consumption (Biomass) (1000T/capita*100) in 2011")
text(x=dom_mat_biom_energy2011$biom_energy_capita, y=dom_mat_biom_energy2011$mat_cons_biomass_capita,labels=dom_mat_biom_energy2011$geo_code, cex= 0.7, pos=3)

#2015
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dom_mat_biom_energy2015 <- sust_sources_unit  %>% 
  select(geo_code:biom_energy_capita,mat_cons_biomass_capita)
dom_mat_biom_energy2015 <- dom_mat_biom_energy2015[dom_mat_biom_energy2015[, "time"] == 2015,] 
dom_mat_biom_energy2015 <- dom_mat_biom_energy2015[order(dom_mat_biom_energy2015$geo_code),]

dom_mat_biom_energy2015 <- dom_mat_biom_energy2015[!duplicated(dom_mat_biom_energy2015),]
dom_mat_biom_energy2015 <- dom_mat_biom_energy2015[ -c(3:6)]

plot(x=dom_mat_biom_energy2015$mat_cons_biomass, y=dom_mat_biom_energy2015$biom_energy,xlab="Domestic material consumption (Biomass) (1000T/capita*100) in 2015",ylab="Total biomass consumed for energy (1000T dry matter/capita*100) in 2015")
text(x=dom_mat_biom_energy2015$mat_cons_biomass, y=dom_mat_biom_energy2015$biom_energy,labels=dom_mat_biom_energy2015$geo_code, cex= 0.7, pos=3)

plot(x=dom_mat_biom_energy2015$biom_energy, y=dom_mat_biom_energy2015$mat_cons_biomass,xlab="Total biomass consumed for energy (1000T dry matter/capita*100) in 2015",ylab="Domestic material consumption (Biomass) (1000T/capita*100) in 2015")
text(x=dom_mat_biom_energy2015$biom_energy, y=dom_mat_biom_energy2015$mat_cons_biomass,labels=dom_mat_biom_energy2015$geo_code, cex= 0.7, pos=3)

#Share of renewable energy in gross final energy consumption (3.1.b.2) and Total biomass consumed for energy (Net trade) (3.4.a.2)
#2011
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
renew_energy_biom_energy2011 <- sust_sources_unit  %>% 
  select(geo_code:biom_energy,renew_energy)
renew_energy_biom_energy2011 <- renew_energy_biom_energy2011[renew_energy_biom_energy2011[, "time"] == 2011,] 
renew_energy_biom_energy2011 <- renew_energy_biom_energy2011[order(renew_energy_biom_energy2011$geo_code),]

plot(x=renew_energy_biom_energy2011$renew_energy, y=renew_energy_biom_energy2011$biom_energy,xlab="Share of renewable energy in gross final energy consumption (%) in 2011",ylab="Total biomass consumed for energy (1000T dry matter) in 2011")
text(x=renew_energy_biom_energy2011$renew_energy, y=renew_energy_biom_energy2011$biom_energy,labels=renew_energy_biom_energy2011$geo_code, cex= 0.7, pos=3)

plot(x=renew_energy_biom_energy2011$biom_energy, y=renew_energy_biom_energy2011$renew_energy,xlab="Total biomass consumed for energy (1000T dry matter) in 2011",ylab="Share of renewable energy in gross final energy consumption (%) in 2011")
text(x=renew_energy_biom_energy2011$biom_energy, y=renew_energy_biom_energy2011$renew_energy,labels=renew_energy_biom_energy2011$geo_code, cex= 0.7, pos=3)

#2015
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
renew_energy_biom_energy2015 <- sust_sources_unit  %>% 
  select(geo_code:biom_energy,renew_energy)
renew_energy_biom_energy2015 <- renew_energy_biom_energy2015[renew_energy_biom_energy2015[, "time"] == 2015,] 
renew_energy_biom_energy2015 <- renew_energy_biom_energy2015[order(renew_energy_biom_energy2015$geo_code),]

plot(x=renew_energy_biom_energy2015$renew_energy, y=renew_energy_biom_energy2015$biom_energy)
text(x=renew_energy_biom_energy2015$renew_energy, y=renew_energy_biom_energy2015$biom_energy,labels=renew_energy_biom_energy2015$geo_code, cex= 0.7, pos=3)

plot(x=renew_energy_biom_energy2015$biom_energy, y=renew_energy_biom_energy2015$renew_energy)
text(x=renew_energy_biom_energy2015$biom_energy, y=renew_energy_biom_energy2015$renew_energy,labels=renew_energy_biom_energy2015$geo_code, cex= 0.7, pos=3)

#Circular material rate (3.1.c.2) and Total biomass consumed for materials (3.4.a.3)
#2011
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
circ_mat_biom_mat2011 <- sust_sources_unit  %>% 
  select(geo_code,time,biom_mat,circ_mat_rate)
circ_mat_biom_mat2011 <- circ_mat_biom_mat2011[circ_mat_biom_mat2011[, "time"] == 2011,] 
circ_mat_biom_mat2011 <- circ_mat_biom_mat2011[order(circ_mat_biom_mat2011$geo_code),]

plot(x=circ_mat_biom_mat2011$biom_mat, y=circ_mat_biom_mat2011$circ_mat_rate,xlab="Total biomass consumed for materials (1000T dry matter) in 2011",ylab="Circular material rate (% of total material use) in 2011")
text(x=circ_mat_biom_mat2011$biom_mat, y=circ_mat_biom_mat2011$circ_mat_rate,labels=circ_mat_biom_mat2011$geo_code, cex= 0.7, pos=3)

plot(x=circ_mat_biom_mat2011$circ_mat_rate, y=circ_mat_biom_mat2011$biom_mat,xlab = "Circular material rate (% of total material use) in 2011",ylab="Total biomass consumed for materials (1000T dry matter) in 2011")
text(x=circ_mat_biom_mat2011$circ_mat_rate, y=circ_mat_biom_mat2011$biom_mat,labels=circ_mat_biom_mat2011$geo_code, cex= 0.7, pos=3)

#2015
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
circ_mat_biom_mat2015 <- sust_sources_unit  %>% 
  select(geo_code,time,biom_mat,circ_mat_rate)
circ_mat_biom_mat2015 <- circ_mat_biom_mat2015[circ_mat_biom_mat2015[, "time"] == 2015,] 
circ_mat_biom_mat2015 <- circ_mat_biom_mat2015[order(circ_mat_biom_mat2015$geo_code),]

plot(x=circ_mat_biom_mat2015$biom_mat, y=circ_mat_biom_mat2015$circ_mat_rate)
text(x=circ_mat_biom_mat2015$biom_mat, y=circ_mat_biom_mat2015$circ_mat_rate,labels=circ_mat_biom_mat2015$geo_code, cex= 0.7, pos=3)

plot(x=circ_mat_biom_mat2015$circ_mat_rate, y=circ_mat_biom_mat2015$biom_mat)
text(x=circ_mat_biom_mat2015$circ_mat_rate, y=circ_mat_biom_mat2015$biom_mat,labels=circ_mat_biom_mat2015$geo_code, cex= 0.7, pos=3)

#Domestic material consumption (biomass) (3.1.a.1) and Total biomass consumed for materials (3.4.a.3)
#2011
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dom_mat_biom_mat2011 <- sust_sources_unit  %>% 
  select(geo_code,time,biom_mat,mat_cons_biomass)
dom_mat_biom_mat2011 <- dom_mat_biom_mat2011[dom_mat_biom_mat2011[, "time"] == 2011,] 
dom_mat_biom_mat2011 <- dom_mat_biom_mat2011[order(dom_mat_biom_mat2011$geo_code),]

plot(x=dom_mat_biom_mat2011$biom_mat, y=dom_mat_biom_mat2011$mat_cons_biomass,xlab="Total biomass consumed for materials (1000T dry matter) in 2011",ylab="Domestic material consumption (Biomass) (1000T) in 2011")
text(x=dom_mat_biom_mat2011$biom_mat, y=dom_mat_biom_mat2011$mat_cons_biomass,labels=dom_mat_biom_mat2011$geo_code, cex= 0.7, pos=3)

plot(x=dom_mat_biom_mat2011$mat_cons_biomass, y=dom_mat_biom_mat2011$biom_mat,xlab="Domestic material consumption (Biomass) (1000T) in 2011",ylab="Total biomass consumed for materials (1000T dry matter) in 2011")
text(x=dom_mat_biom_mat2011$mat_cons_biomass, y=dom_mat_biom_mat2011$biom_mat,labels=dom_mat_biom_mat2011$geo_code, cex= 0.7, pos=3)

#2015
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dom_mat_biom_mat2015 <- sust_sources_unit  %>% 
  select(geo_code,time,biom_mat,mat_cons_biomass)
dom_mat_biom_mat2015 <- dom_mat_biom_mat2015[dom_mat_biom_mat2015[, "time"] == 2015,] 
dom_mat_biom_mat2015 <- dom_mat_biom_mat2015[order(dom_mat_biom_mat2015$geo_code),]

plot(x=dom_mat_biom_mat2015$biom_mat, y=dom_mat_biom_mat2015$mat_cons_biomass)
text(x=dom_mat_biom_mat2015$biom_mat, y=dom_mat_biom_mat2015$mat_cons_biomass,labels=dom_mat_biom_mat2015$geo_code, cex= 0.7, pos=3)

plot(x=dom_mat_biom_mat2015$mat_cons_biomass, y=dom_mat_biom_mat2015$biom_mat)
text(x=dom_mat_biom_mat2015$mat_cons_biomass, y=dom_mat_biom_mat2015$biom_mat,labels=dom_mat_biom_mat2015$geo_code, cex= 0.7, pos=3)

#Material footprint (biomass) (3.1.a.2) and Total biomass consumed for materials (3.4.a.3)
#2011
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mat_footprint_biom_mat2011 <- sust_sources_unit  %>% 
  select(geo_code,time,biom_mat,mat_footprint_biom)
mat_footprint_biom_mat2011 <- mat_footprint_biom_mat2011[mat_footprint_biom_mat2011[, "time"] == 2011,] 
mat_footprint_biom_mat2011 <- mat_footprint_biom_mat2011[order(mat_footprint_biom_mat2011$geo_code),]

plot(x=mat_footprint_biom_mat2011$biom_mat, y=mat_footprint_biom_mat2011$mat_footprint_biom,xlab = "Total biomass consumed for materials (1000T dry matter) in 2011", ylab = "Material footprint (biomass) (Material footprint biomass per capita) in 2011")
text(x=mat_footprint_biom_mat2011$biom_mat, y=mat_footprint_biom_mat2011$mat_footprint_biom,labels=mat_footprint_biom_mat2011$geo_code, cex= 0.7, pos=3)

plot(x=mat_footprint_biom_mat2011$mat_footprint_biom, y=mat_footprint_biom_mat2011$biom_mat,xlab = "Material footprint (biomass) (Material footprint biomass per capita) in 2011", ylab = "Total biomass consumed for materials (1000T dry matter) in 2011")
text(x=mat_footprint_biom_mat2011$mat_footprint_biom, y=mat_footprint_biom_mat2011$biom_mat,labels=mat_footprint_biom_mat2011$geo_code, cex= 0.7, pos=3)

#2015
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mat_footprint_biom_mat2015 <- sust_sources_unit  %>% 
  select(geo_code,time,biom_mat,mat_footprint_biom)
mat_footprint_biom_mat2015 <- mat_footprint_biom_mat2015[mat_footprint_biom_mat2015[, "time"] == 2015,] 
mat_footprint_biom_mat2015 <- mat_footprint_biom_mat2015[order(mat_footprint_biom_mat2015$geo_code),]

plot(x=mat_footprint_biom_mat2015$biom_mat, y=mat_footprint_biom_mat2015$mat_footprint_biom)
text(x=mat_footprint_biom_mat2015$biom_mat, y=mat_footprint_biom_mat2015$mat_footprint_biom,labels=mat_footprint_biom_mat2015$geo_code, cex= 0.7, pos=3)

plot(x=mat_footprint_biom_mat2015$mat_footprint_biom, y=mat_footprint_biom_mat2015$biom_mat)
text(x=mat_footprint_biom_mat2015$mat_footprint_biom, y=mat_footprint_biom_mat2015$biom_mat,labels=mat_footprint_biom_mat2015$geo_code, cex= 0.7, pos=3)

#Domestic Material Consumption (biomass) (3.1.a.1) and Circular material rate (3.1.c.2)
#2011
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dom_mat_cons_circ_mat2011 <- sust_sources_unit  %>% 
  select(geo_code,time,circ_mat_rate,mat_cons_biomass)
dom_mat_cons_circ_mat2011 <- dom_mat_cons_circ_mat2011[dom_mat_cons_circ_mat2011[, "time"] == 2011,] 
dom_mat_cons_circ_mat2011 <- dom_mat_cons_circ_mat2011[order(dom_mat_cons_circ_mat2011$geo_code),]

plot(x=dom_mat_cons_circ_mat2011$circ_mat_rate, y=dom_mat_cons_circ_mat2011$mat_cons_biomass,xlab="Circular material rate (% of total material use) in 2011",ylab="Domestic material consumption (Biomass) (1000T) in 2011")
text(x=dom_mat_cons_circ_mat2011$circ_mat_rate, y=dom_mat_cons_circ_mat2011$mat_cons_biomass,labels=dom_mat_cons_circ_mat2011$geo_code, cex= 0.7, pos=3)

plot(x=dom_mat_cons_circ_mat2011$mat_cons_biomass, y=dom_mat_cons_circ_mat2011$circ_mat_rate,xlab="Domestic material consumption (Biomass) (1000T) in 2011",ylab="Circular material rate (% of total material use) in 2011")
text(x=dom_mat_cons_circ_mat2011$mat_cons_biomass, y=dom_mat_cons_circ_mat2011$circ_mat_rate,labels=dom_mat_cons_circ_mat2011$geo_code, cex= 0.7, pos=3)

#2015
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dom_mat_cons_circ_mat2015 <- sust_sources_unit  %>% 
  select(geo_code,time,circ_mat_rate,mat_cons_biomass)
dom_mat_cons_circ_mat2015 <- dom_mat_cons_circ_mat2015[dom_mat_cons_circ_mat2015[, "time"] == 2015,] 
dom_mat_cons_circ_mat2015 <- dom_mat_cons_circ_mat2015[order(dom_mat_cons_circ_mat2015$geo_code),]

plot(x=dom_mat_cons_circ_mat2015$circ_mat_rate, y=dom_mat_cons_circ_mat2015$mat_cons_biomass)
text(x=dom_mat_cons_circ_mat2015$circ_mat_rate, y=dom_mat_cons_circ_mat2015$mat_cons_biomass,labels=dom_mat_cons_circ_mat2015$geo_code, cex= 0.7, pos=3)

plot(x=dom_mat_cons_circ_mat2015$mat_cons_biomass, y=dom_mat_cons_circ_mat2015$circ_mat_rate)
text(x=dom_mat_cons_circ_mat2015$mat_cons_biomass, y=dom_mat_cons_circ_mat2015$circ_mat_rate,labels=dom_mat_cons_circ_mat2015$geo_code, cex= 0.7, pos=3)

#Material footprint (biomass) (3.1.a.2) and Circular material rate (3.1.c.2)
#2011
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mat_footprint_circ_mat2011 <- sust_sources_unit  %>% 
  select(geo_code,time,circ_mat_rate,mat_footprint_biom)
mat_footprint_circ_mat2011 <- mat_footprint_circ_mat2011[mat_footprint_circ_mat2011[, "time"] == 2011,] 
mat_footprint_circ_mat2011 <- mat_footprint_circ_mat2011[order(mat_footprint_circ_mat2011$geo_code),]

plot(x=mat_footprint_circ_mat2011$circ_mat_rate, y=mat_footprint_circ_mat2011$mat_footprint_biom,xlab="Circular material rate (% of total material use) in 2011",ylab="Material footprint (biomass) (Material footprint biomass per capita) in 2011")
text(x=mat_footprint_circ_mat2011$circ_mat_rate, y=mat_footprint_circ_mat2011$mat_footprint_biom,labels=mat_footprint_circ_mat2011$geo_code, cex= 0.7, pos=3)

plot(x=mat_footprint_circ_mat2011$mat_footprint_biom, y=mat_footprint_circ_mat2011$circ_mat_rate,xlab="Material footprint (biomass) (Material footprint biomass per capita) in 2011",ylab="Circular material rate (% of total material use) in 2011")
text(x=mat_footprint_circ_mat2011$mat_footprint_biom, y=mat_footprint_circ_mat2011$circ_mat_rate,labels=mat_footprint_circ_mat2011$geo_code, cex= 0.7, pos=3)

#2015
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mat_footprint_circ_mat2015 <- sust_sources_unit  %>% 
  select(geo_code,time,circ_mat_rate,mat_footprint_biom)
mat_footprint_circ_mat2015 <- mat_footprint_circ_mat2015[mat_footprint_circ_mat2015[, "time"] == 2015,] 
mat_footprint_circ_mat2015 <- mat_footprint_circ_mat2015[order(mat_footprint_circ_mat2015$geo_code),]

plot(x=mat_footprint_circ_mat2015$circ_mat_rate, y=mat_footprint_circ_mat2015$mat_footprint_biom)
text(x=mat_footprint_circ_mat2015$circ_mat_rate, y=mat_footprint_circ_mat2015$mat_footprint_biom,labels=mat_footprint_circ_mat2015$geo_code, cex= 0.7, pos=3)

plot(x=mat_footprint_circ_mat2015$mat_footprint_biom, y=mat_footprint_circ_mat2015$circ_mat_rate)
text(x=mat_footprint_circ_mat2015$mat_footprint_biom, y=mat_footprint_circ_mat2015$circ_mat_rate,labels=mat_footprint_circ_mat2015$geo_code, cex= 0.7, pos=3)

#Domestic Material Consumption (biomass) (3.1.a.1) and Energy productivity (3.1.b.1)
#2011
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dom_mat_energy_prod2011 <- sust_sources_unit  %>% 
  select(geo_code,time,energy_prod,mat_cons_biomass)
dom_mat_energy_prod2011 <- dom_mat_energy_prod2011[dom_mat_energy_prod2011[, "time"] == 2011,] 
dom_mat_energy_prod2011 <- dom_mat_energy_prod2011[order(dom_mat_energy_prod2011$geo_code),]

plot(x=dom_mat_energy_prod2011$energy_prod, y=dom_mat_energy_prod2011$mat_cons_biomass,xlab="Energy productivity (???/kg of oil equivalent)",ylab="Domestic material consumption (Biomass) (1000T) in 2011")
text(x=dom_mat_energy_prod2011$energy_prod, y=dom_mat_energy_prod2011$mat_cons_biomass,labels=dom_mat_energy_prod2011$geo_code, cex= 0.7, pos=3)

plot(x=dom_mat_energy_prod2011$mat_cons_biomass, y=dom_mat_energy_prod2011$energy_prod,xlab="Domestic material consumption (Biomass) (1000T) in 2011",ylab="Energy productivity (???/kg of oil equivalent)")
text(x=dom_mat_energy_prod2011$mat_cons_biomass, y=dom_mat_energy_prod2011$energy_prod,labels=dom_mat_energy_prod2011$geo_code, cex= 0.7, pos=3)

#2015
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dom_mat_energy_prod2015 <- sust_sources_unit  %>% 
  select(geo_code,time,energy_prod,mat_cons_biomass)
dom_mat_energy_prod2015 <- dom_mat_energy_prod2015[dom_mat_energy_prod2015[, "time"] == 2015,] 
dom_mat_energy_prod2015 <- dom_mat_energy_prod2015[order(dom_mat_energy_prod2015$geo_code),]

plot(x=dom_mat_energy_prod2015$energy_prod, y=dom_mat_energy_prod2015$mat_cons_biomass)
text(x=dom_mat_energy_prod2015$energy_prod, y=dom_mat_energy_prod2015$mat_cons_biomass,labels=dom_mat_energy_prod2015$geo_code, cex= 0.7, pos=3)

plot(x=dom_mat_energy_prod2015$mat_cons_biomass, y=dom_mat_energy_prod2015$energy_prod)
text(x=dom_mat_energy_prod2015$mat_cons_biomass, y=dom_mat_energy_prod2015$energy_prod,labels=dom_mat_energy_prod2015$geo_code, cex= 0.7, pos=3)

#Material footprint (biomass) (3.1.a.2) and Energy productivity (3.1.b.1)
#2011
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mat_footprint_energy_prod2011 <- sust_sources_unit  %>% 
  select(geo_code,time,energy_prod,mat_footprint_biom)
mat_footprint_energy_prod2011 <- mat_footprint_energy_prod2011[mat_footprint_energy_prod2011[, "time"] == 2011,] 
mat_footprint_energy_prod2011 <- mat_footprint_energy_prod2011[order(mat_footprint_energy_prod2011$geo_code),]

plot(x=mat_footprint_energy_prod2011$energy_prod, y=mat_footprint_energy_prod2011$mat_footprint_biom,xlab="Energy productivity (???/kg of oil equivalent)",ylab = "Material footprint (biomass) (Material footprint biomass per capita) in 2011")
text(x=mat_footprint_energy_prod2011$energy_prod, y=mat_footprint_energy_prod2011$mat_footprint_biom,labels=mat_footprint_energy_prod2011$geo_code, cex= 0.7, pos=3)

plot(x=mat_footprint_energy_prod2011$mat_footprint_biom, y=mat_footprint_energy_prod2011$energy_prod,xlab = "Material footprint (biomass) (Material footprint biomass per capita) in 2011",ylab="Energy productivity (???/kg of oil equivalent)")
text(x=mat_footprint_energy_prod2011$mat_footprint_biom, y=mat_footprint_energy_prod2011$energy_prod,labels=mat_footprint_energy_prod2011$geo_code, cex= 0.7, pos=3)

#2015
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mat_footprint_energy_prod2015 <- sust_sources_unit  %>% 
  select(geo_code,time,energy_prod,mat_footprint_biom)
mat_footprint_energy_prod2015 <- mat_footprint_energy_prod2015[mat_footprint_energy_prod2015[, "time"] == 2015,] 
mat_footprint_energy_prod2015 <- mat_footprint_energy_prod2015[order(mat_footprint_energy_prod2015$geo_code),]

plot(x=mat_footprint_energy_prod2015$energy_prod, y=mat_footprint_energy_prod2015$mat_footprint_biom)
text(x=mat_footprint_energy_prod2015$energy_prod, y=mat_footprint_energy_prod2015$mat_footprint_biom,labels=mat_footprint_energy_prod2015$geo_code, cex= 0.7, pos=3)

plot(x=mat_footprint_energy_prod2015$mat_footprint_biom, y=mat_footprint_energy_prod2015$energy_prod) 
text(x=mat_footprint_energy_prod2015$mat_footprint_biom, y=mat_footprint_energy_prod2015$energy_prod,labels=mat_footprint_energy_prod2015$geo_code, cex= 0.7, pos=3)