# Script for two tests of diffusion simulation
# File:  testDiffusion.R
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

#Declare globa variables hot,cold and ambient.
utils::globalVariables(c("COLD", "HOT","AMBIENT","m","n"))
AMBIENT = 25.0;
HOT = 50.0;
COLD = 0.0;

#########################
# Test 1
# par(mar = rep(0, 4))
# m = 3;
# n = 5;
# diffusionRate=0.1;

# hotSites = matrix(c(2,1),ncol=2)
# coldSites=matrix(c(3,5),ncol=2)
# t=2;

# grids = diffusionSim(m,n,diffusionRate, hotSites, coldSites,t);
# animDiffusionGray(grids)
#animDiffusionColor(grids)

#########################
# Test 2
par(mar = rep(0, 4))
m = 20;
n = 60;
diffusionRate = 0.05
hotSites = matrix(rep(1,8),ncol=2) 
hotSites[1, ] = c(floor(m/2)-1,1)
hotSites[2,] = c(floor(m/2),1) 
hotSites[3,] = c(floor(m/2)+1,1) 
hotSites[4,] = c(1,floor(3*n/4))  

coldSites = matrix(rep(1,10),ncol=2) 
coldSites[1,] = c(m,floor(n/3)-1) 
coldSites[2,] = c(m,floor(n/3)) 
coldSites[3,] = c(m,floor(n/3)+1) 
coldSites[4,] =c (m,floor(n/3)+2) 
coldSites[5,] = c(m,floor(n/3)+3)  
t = 300;

grids = diffusionSim(m, n, diffusionRate, hotSites, coldSites, t);
animDiffusionGray(grids)
animDiffusionColor(grids)