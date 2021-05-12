#************************************************************************
# Title: Blue Fertility Effect on Red Extinction Experiment 1
# Author: William Murrah
# Description: Textbook example of BehaviorSpace Experiment
# Created: Saturday, 01 May 2021
# R version: R version 4.0.5 (2021-03-31)
# Project(working) directory: /Users/wmm0017/Projects/Learning/computationalScience/products/ABIBM_Railsback_Grimm
#************************************************************************
library(ggplot2)
BonRdat <- read.csv("data/Simple Birth Rates Blue_fertility_effect_on_red_extinction-table.csv",
                    header = TRUE, skip = 6)

BonRdat$MeanTicks <- ave(BonRdat$ticks, BonRdat$blue.fertility)


ggplot(BonRdat, aes(x = blue.fertility, y = MeanTicks)) + 
  geom_point(aes(y = ticks), alpha = .3) +
  geom_line(color = "black") +
  geom_point(size = 2, color = "red")  


