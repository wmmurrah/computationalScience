# PopsAndMatOps.R
# Module 13.2
# Introduction to Computational Science -- Shiflet & Shiflet
# Module 10.3
# Introduction to Computational Science:
# Modeling and Simulation for the Sciences, 2nd Edition
# Angela B. Shiflet and George W. Shiflet
# Wofford College
# © 2014 by Princeton University Press
#
# R solution by Callixte Nahiman, Wofford College

w = c(20.00, 6.57, 4.69, 3.08, 0.99, 0.02)

## The using blanks like in matlab doesn't apply in R
# b = [15.00 5.37 4.84 6.00 10.83 27.43] this is only valid in Matlab, not in R

 b = c(15.00, 5.37, 4.84, 6.00, 10.83, 27.43)

# column vector uses semicolons to separate elements, you can also use cbind.
###################################################

b_col = matrix(c(15.00, 5.37, 4.84, 6.00, 10.83, 27.43),ncol=1)
cbind(c(15.00, 5.37, 4.84, 6.00, 10.83, 27.43))
# 4th element of b
b[4]

# test if equal

all(b == b)
all(b == w)
all(b ==c (1.00, 5.37, 4.84, 6.00, 10.83, 27.43))

# addition of vectors
w + b

# Multiplication by a scalar
100 * w

# Dot Product
e = c(280, 70);
b = c(291, 9483);
#dot(e, b)
e %*% b
# Size of a vector
length(e)

# Matrices 
## Semicolons doesn't apply in R: you have to specify the number of colums
## use cbind for columns bind and rbind for row binds
## you will have to put together all rows which are vectors each single one
#S = [20.00 15.00; 6.57 5.27; 4.69 4.84; 3.08 6.00; 0.99 10.83; 0.02 27.43]

S = rbind(c(20.00, 15.00), c(6.57, 5.27),c( 4.69, 4.84),c( 3.08, 6.00), c(0.99, 10.83),c( 0.02, 27.43))
S = matrix(c(20.00, 15.00, 6.57, 5.27, 4.69, 4.84, 3.08, 6.00, 0.99, 10.83, 0.02, 27.43),nrow=6,ncol=2,byrow=TRUE)

# Scalar Multiplication 
100 * S

# Matrix Sums
S + S

# Matrix Multiplication
S %*% matrix(c(20, 18),ncol=1)

#A = [20 0.25 0.30; 18 0.00 0.20]
A = rbind(c(20, 0.25, 0.30),c( 18, 0.00, 0.2))

S %*% A

# Transpose - switch rows and columns
w
#  w' in R corresponds to:
t(w)
# and S' correpsonds to
t(S)
