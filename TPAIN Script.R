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
