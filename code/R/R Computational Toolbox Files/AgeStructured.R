# Age structrued function 
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
# R solution by Callixte Nahiman, Wofford College

AgeStructured<-function ( prob1to2, prob2to3 ){


#    AGESTRUCTURED Dominant eigenvalue of age-structure matrix
#    AgeStructured( prob1to2, prob2to3 ) returns
#    the dominant eigenvalue of the 3-by-3 age structured matrix
#    [0 5 4; prob1to2 0 0; 0 prob2to3 0].

mat = rbind(c(0, 5, 4),c(prob1to2, 0, 0),c( 0, prob2to3, 0)

#eigenvalues

eigenvalues = eigen(mat)$values

#eigenvalues = eig(mat);
#dominantEig = max(abs(eigenvalues));
dominantEig= max(abs(eigen(mat)$values))
}
