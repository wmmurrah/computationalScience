# Module 9.4
# File: Distributions.R
# Introduction to Computational Science -- Shiflet & Shiflet
# Module 10.3
# Introduction to Computational Science:
# Modeling and Simulation for the Sciences, 2nd Edition
# Angela B. Shiflet and George W. Shiflet
# Wofford College
# © 2014 by Princeton University Press
#
# R solution by Stephen Davies, University of Mary Washington

#############################
# Statistical Distributions

# Generate 10000 uniformly distributed random numbers between 0.0 and 1.0
# and generate histogram with 10 categories
tbl = runif(10000)
hist(tbl, breaks=10)

readline("Press RETURN to continue.")

##############################
# Normal Distributions
# A normal or Gaussian distribution, which statistics frequently employs,
# uses two parameters: a mean (often called mu) and a standard devation
# (often called sigma).
# To generate random numbers according to this distribution, we use the
# rnorm function:
#     rnorm(10, mean=70, sd=5)
# This would generate 10 normally distributed random numbers with a mean of
# 70 and a standard deviation of 5. We can plot the probability density
# function itself using the "dnorm()" function:
plot(dnorm(seq(50,90,.1),mean=70, sd=5))

readline("Press RETURN to continue.")

# Generate one random number from normal distribution with mean 0 and
# standard deviation 1.
r = rnorm(1)

# Generate 1000 random numbers from normal distribution with mean 0 and
# standard deviation 1. Display histogram.
tblNormal = rnorm(1000)
hist(tblNormal, breaks=13)

readline("Press RETURN to continue.")

# Generate 1000 random numbers from normal distribution with mean 3 and
# standard deviation 5. Display histogram.
tblNormal = rnorm(1000, mean=3, sd=5)
hist(tblNormal, breaks=13)

readline("Press RETURN to continue.")
