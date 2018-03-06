library("dplyr")
library("reshape2")
library("ggthemes") 
library(ggplot2)
library("maps")
library("tidyr")

# FIRST TAB DATA 
map <- map_data(map="world")

gdp <- read.csv("data/gdp.csv", stringsAsFactors = FALSE, skip = 4)
gdp <- gdp[ , -3]
gdp <- gdp[ , -3]
gdp <- melt(gdp, id.vars = c("Country.Name", "Country.Code"))
colnames(gdp) <- c("Name", "Code", "Year", "GDP") 

# SECOND TAB DATA 


