##TPC curves, maps, temperature and nutrient analysis for TPAIN

rm(list=ls())

##Install packages
# load packages
library(nls.multstart)
library(broom)
library(purrr)
library(tidyverse)
library(nlstools)
library(nls2)
library(grid)
library(gridExtra)
library(cowplot)
library(lubridate)
library(directlabels)
library(rgdal)
library(rgeos)
library(ggthemes)
library(ggsn)
library(sp)
library(ggrepel)
library(raster)
library(rgdal)
library(patchwork)
#load data

photo.data <- read.csv("TPAIN data.csv")
photo.data$X <- NULL
View(photo.data)
glimpse(photo.data)

#decide color scheme for the plots
#cols<-c("#99817b", "#F2C3A7", "#FEF3E1", "#C489B9")
cols<-c("#073e3e", "#c35119", "#f896b0", "#e4e0ca")

mydata <- photo.data

# convert temp to K
mydata$K<-mydata$Temp.C + 273.15

#define the Sharpe-Schoolfield equation
schoolfield_high <- function(lnc, E, Eh, Th, temp, Tc) {
  Tc <- 273.15 + Tc
  k <- 8.62e-5
  boltzmann.term <- lnc + log(exp(E/k*(1/Tc - 1/temp))) #units are eV/K, electrovolts/Kelvin
  inactivation.term <- log(1/(1 + exp(Eh/k*(1/Th - 1/temp))))
  return(boltzmann.term + inactivation.term)
}

# fit over each set of groupings

#droplevels(mydata$Organism.ID) ###DOES NOT WORK ###WHAT DOES THIS DO?
mydata$Treatment<-as.character(mydata$Treatment)
mydata$Organism.ID<-as.character(mydata$Organism.ID)

fits <- mydata %>%
  group_by(Organism.ID, Treatment) %>%
  nest() %>%
  mutate(fit = purrr::map(data, ~ nls_multstart(log.rate ~ schoolfield_high(lnc, E, Eh, Th, temp = K, Tc = 26),
                                                data = .x,
                                                iter = 1000,
                                                start_lower = c(lnc = -10, E = 0.1, Eh = 0.2, Th = 285),
                                                start_upper = c(lnc = 10, E = 2, Eh = 5, Th = 330),
                                                supp_errors = 'Y',
                                                na.action = na.omit,
                                                lower = c(lnc = -10, E = 0, Eh = 0, Th = 0))))


