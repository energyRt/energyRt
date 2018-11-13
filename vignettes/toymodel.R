## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup2, include=FALSE-----------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
#knitr::opts_chunk$set(fig_width = 8, fig_height = 6)
library(energyRt)
library(lubridate)
library(tibble)
library(tidyverse)
# Chose your default solver, comment another
# solver <- "GLPK"
solver <- "GAMS" 
if(exists("../temp/_gams_link.R")) source("../temp/_gams_link.R")


## ----Regions-------------------------------------------------------------
if (!file.exists("../data/usa9reg.RData")) {
  stop("US map data is not found. Follow the steps in 'usa_maps.R'")
} else {
  load("../data/usa9reg.RData")
}

ggplot(usa9r, aes(long,lat, group = group)) + 
  geom_polygon(aes(fill = id), colour = rgb(1,1,1,0.2)) +
  # geom_polygon(aes(fill = id), colour = "white", size = 1) + 
  theme(legend.position="none") +
  labs(fill = "Region") +
  #coord_quickmap() +
  theme_void()
b <- last_plot()

(reg_names <- as.character(usa9reg@data$region))
(nreg <- length(reg_names))

# Neighbor regions
if (!any((installed.packages())[, "Package"] == "spdep")) install.packages("spdep")
nbr <- spdep::poly2nb(usa9reg)



