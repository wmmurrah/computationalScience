#************************************************************************
# Title: flocking baseline
# Author: William Murrah
# Description: Baseline run of flocking example in ABIBM chapter 8.
# Created: Sunday, 02 May 2021
# R version: R version 4.0.5 (2021-03-31)
# Project(working) directory: /Users/wmm0017/Projects/Learning/computationalScience/products/ABIBM_Railsback_Grimm
#************************************************************************
library(ggplot2)

flockdat <- read.csv(file = "data/Flocking-Baseline2-table.csv",
                     header = TRUE, skip = 6)

# Fix variable names
names(flockdat) <- gsub("X\\.|\\.$|\\.any|\\.turtles","", names(flockdat))
names(flockdat) <- gsub("\\.\\.|\\.\\.\\.", ".", names(flockdat))

names(flockdat)[names(flockdat) == "mean.count.flockmates.of"] <-
   "mean.flockmates"
names(flockdat)[names(flockdat) == 
                  "mean.min.distance.myself.of.other.of"] <- 
    "mean.separation"
names(flockdat)[names(flockdat) == 
                  "standard.deviation.heading.of"] <- 
  "sd.heading"

# Remove first row which is invalid (see p. 112, last sentence).
flockdat <- flockdat[-1, ]
ggplot(flockdat, aes(x = step, y = mean.flockmates)) + 
  geom_smooth(method = "loess", se = TRUE, span = .01) + geom_line(alpha = .2)

ggplot(flockdat, aes(x = step, y = sd.heading)) +
  geom_smooth(method = "loess", se = FALSE, span = .01) + geom_line(alpha = .2)

