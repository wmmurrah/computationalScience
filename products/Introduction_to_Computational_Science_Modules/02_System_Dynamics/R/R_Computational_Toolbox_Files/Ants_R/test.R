# Script for tests of ants simulation
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

# Add multiple test for differnt values of t and n respectively
require(graphics)
source("source.R")
#Declare globa variables hot,cold and ambient.
utils::globalVariables(c("MAXPHER", "EVAPORATE","DEPOSIT","THRESHOLD"))

EMPTY = 0
NORTH = 1
EAST = 2
SOUTH = 3
WEST = 4
STAY = 5
BORDER = 6

#global MAXPHER EVAPORATE DEPOSIT THRESHOLD
set.seed(3)

MAXPHER = 50;
EVAPORATE = 1;
DEPOSIT = 2;
THRESHOLD = 0;

# test
ans = ants(21, 0.1, 0.01, 20)
antGrids= ans[[1]]
pherGrids = ans[[2]]
showGraphs(antGrids, pherGrids)

# another test
# ans = ants(31, 0.05, 0.01, 50)
# antGrids= ans[[1]]
# pherGrids = ans[[2]]
# showGraphs(antGrids, pherGrids)