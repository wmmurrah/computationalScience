# Script for tests of biofilm simulation
# File:  test.R
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 10.3
# Introduction to Computational Science:
# Modeling and Simulation for the Sciences, 2nd Edition
# Angela B. Shiflet and George W. Shiflet
# Wofford College
# © 2014 by Princeton University Press
#
# R solution by Callixte Nahiman 
# and Angela Shiflet, Wofford College


utils::globalVariables(c("MAXNUTRIENT", "CONSUMED", "EMPTY", "BACTERIUM", "DEAD", "BORDER", "USED"))

m =10
n=10
t=20
p=0.5

probInitBacteria = 0.4
diffusionRate = 0.1 
MAXNUTRIENT = 1.0
CONSUMED = 0.1
EMPTY = 0
BACTERIUM = 1
DEAD = 2
BORDER = 3
USED = 4 

# bacGridsANDnutGrids = biofilm( m, n, probInitBacteria, diffusionRate, p, t )
# bacGridsANDnutGrids = biofilm(10, 10, .5, .1, 1, 40)
# bactGrids = bacGridsANDnutGrids[[1]]
# nutGrids = bacGridsANDnutGrids[[2]]
# showBacteriaGraphs(bacGridsANDnutGrids[[1]])
# playBac = showBacteriaGraphs(bacGridsANDnutGrids[[1]])
# dev.new()
# playNut = showNutrientGraphs(bacGridsANDnutGrids[[2]])
# dev.new()

## another test
# bacGridsANDnutGrids= biofilm(50, 20, .5, .1, 1, 130)
# dev.new()
# playBac = showBacteriaGraphs(bacGridsANDnutGrids[[1]])
# dev.new()
# playNut = showNutrientGraphs(bacGridsANDnutGrids[[2]])


## another test
bacGridsANDnutGrids = biofilm(50, 20, .5, .1, 0.3, 130)
dev.new()
playBac = showBacteriaGraphs(bacGridsANDnutGrids[[1]])
dev.new()
playNut = showNutrientGraphs(bacGridsANDnutGrids[[2]])


# ## another test
# bacGridsANDnutGrids = biofilm(50, 50, 0.25, 0.05, 0.5, 100)
# dev.new()
# playBac = showBacteriaGraphs(bacGridsANDnutGrids[[1]])
# dev.new()
# playNut = showNutrientGraphs(bacGridsANDnutGrids[[2]])
