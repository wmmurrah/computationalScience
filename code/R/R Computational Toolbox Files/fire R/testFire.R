# Simulation of forest fire 
# File:  testFire.R
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 10.3
# Introduction to Computational Science:# Modeling and Simulation for the Sciences, 2nd Edition# Angela B. Shiflet and George W. Shiflet# Wofford College# © 2014 by Princeton University Press
#
# R solution by Stephen Davies, University of Mary Washington, 
# and Angela Shiflet, Wofford College

source("source.R")

## test grids = fire(n, probTree, probBurning, probLightning, probImmune, t)
grids = fire(15, 0.8, 0.001, 0.001, 0.3, 20)
showGraphs(grids)

##
# probLightning = 0
# probImmune = 0
fireList =fire(20, 0.5, 0.5,0.5, 0.5, 5)
showGraphs(fireList)

##
# probLightning small
# probImmune = 0
fireList = fire(20,0.3,0.01,0,0,15)
showGraphs(fireList)

##
# probLightning = 0
# probImmune = 0.52
fireList = fire(20,0.3,0.2,0,0.52,25)
showGraphs(fireList)
