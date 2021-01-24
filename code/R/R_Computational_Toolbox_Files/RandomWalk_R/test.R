# Script for tests of random walk simulation
# File:  test.R
# Introduction to Computational Science -- Shiflet & Shiflet
# Module 10.3
# Introduction to Computational Science:
# Modeling and Simulation for the Sciences, 2nd Edition
# Angela B. Shiflet and George W. Shiflet
# Wofford College
# © 2014 by Princeton University Press
#
# R solution by Stephen Davies, University of Mary Washington, 
# and Angela Shiflet, Wofford College

source("randomWalkPoints.R")
source("animateWalk.R")

# test
lst = randomWalkPoints(25)
animateWalk(lst)
