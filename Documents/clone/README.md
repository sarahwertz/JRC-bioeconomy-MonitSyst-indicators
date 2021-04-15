This repository contains R scripts related to the SUSBIOM project of the Bioeconomy unit. 

The scripts were written in the framework of a traineeship. The author is Sarah Wertz with the help of colleagues Paul Rougieux, Nicolas Robert and Candan Kilsedar.

The different scripts will enable the user to analyze indicators of the EU Bioeconomy Monitoring System by adapting their data to be fit-for-purpose for the assessment of the trade-offs and synergies between them.

The indicators taken into account are those for which there was data available at the time of writing (April 2021).

Different scripts are available:
s0_setworking.R: The first script sets up the R working environment, or workspace. A few lines are then dedicated to the installation of the necessary packages to use the underlying functions called in the following scripts.

The 5 scripts, s1_in_so1.R, s1_in_so2.R, s1_in_so3.R, s1_in_so4.R, s1_in_so5.R, prepare and read the data of the indicators for which there was data available at the time of writing for the 5 EU strategy objectives (https://ec.europa.eu/info/research-and-innovation/research-area/bioeconomy/bioeconomy-strategy_en). 

The 5 following scripts s2_correlations_so1.R to s2_correlations_so5.R enable the user to compute correlations between pairs of indicators for each of the EU strategy objectives and visualize the results.

The script s1_in_biomass.R prepares the data linked to biomass, waste and energy in the MS, which is a combination of different EU strategy objectives: 1 and 3.
The aim is to analyze which indicators are redundant and which ones are not going in the same direction to then create a composite indicator, answering this type of question:
“Which MS is best at improving resource efficiency, waste prevention and waste re-use along the whole bioeconomy value chain? 

The script s2_biomass_vizualization.R is linked to the previous one and enables the user to inspect the data; observe the relationship between two indicators by creating scatter plots.

Data necessary for the computation of these correlations are in the "output_data" folder coming from the "master" branch. CSV formats are used. 
The definition and interpretation of each indicator can be found in the annexes of the scientific report "Implementation of the EU Bioeconomy Monitoring System dashboards"(https://ec.europa.eu/jrc/en/publication/eur-scientific-and-technical-research-reports/implementation-eu-bioeconomy-monitoring-system-dashboards).

