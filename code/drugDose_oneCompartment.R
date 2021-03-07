#************************************************************************
# Title: drugDose_oneCompartment
# Author: William Murrah
# Description: code for R systems dynamics tutorial
# Created: Monday, 25 January 2021
# R version: R version 4.0.3 (2020-10-10)
# Project(working) directory: /Users/wmm0017/Projects/Learning/computationalScience
#************************************************************************

half_life <- 3.2       # hrs
plasma_volume <- 3000  # ml

elimination_constant <- -log(0.5)/half_life # 1/h

aspirin_in_plasma <- vector()
aspirin_in_plasma[1] <- 2*325*1000 # ug

simulation_hours <- 8  # h
deltaX <- 5/60         # h
x <- seq(0, simulation_hours, deltaX)

xtoi <- function(x) x/deltaX + 1
itox <- function(i) (i-1)*deltaX

for(i in 2:length(x)) {
  elimination <- (elimination_constant * aspirin_in_plasma[i-1]) * 
    deltaX
  aspirin_in_plasma[i] <- aspirin_in_plasma[i-1] - elimination
}

plasma_Concentration <- aspirin_in_plasma/plasma_volume

plot(plasma_Concentration ~ x, type = "l",
     ylim = c(0, 500),
     xlab = "hours",
     ylab = "Plasma Concentration (ug/ml)",
     main = "Aspirin concentration over time")
abline(h = 150, col = "blue")
abline(h = 350, col = "red")
