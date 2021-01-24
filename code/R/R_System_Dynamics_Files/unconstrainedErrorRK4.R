
# Simulation of unconstrained growth, along with exact value and relative
#   error using Runge-Kutta 4 method
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 5.2
# R solution by Stephen Davies, University of Mary Washington

# Compare the output of this program with:
#    unconstrainedErrorEuler.R and 
#    unconstrainedErrorRK2.R 
# and see how much better it is for various values of deltaT. It's amazing!

deltaT = 1
simLength = 100
initialPopulation = 100
x = seq(0,100,deltaT)

growthRate = .1

# The "estPopulation" vector will store the values the RK4 method predicts
# for the population at each time step. Since this is a very simple
# function that has a known analytical solution, "truePopulation" will be
# used to store the actual, exact population. (Note that computing the
# actual, exact population like this is only possible under very restricted
# circumstances, when the differential equation is simple enough to be
# solved analytically.)
# We can compare the two to see how far off RK4 is from the true answer.
estPopulation = vector(length=length(x))
estPopulation[1] = initialPopulation
truePopulation = vector(length=length(x))
truePopulation[1] = initialPopulation

for (i in 2:length(x)) {

    # 1. P' at previous (left) point (Euler's method just uses this)
    pPrime = estPopulation[i-1] * growthRate

    # 2a. Estimate P at midpoint btwn prev and current point
    estIndividualsMid = estPopulation[i-1] + pPrime * deltaT/2
    # 2b. Estimate P' at midpoint btwn prev and current point
    pPrime2 = estIndividualsMid * growthRate

    # 3a. Estimate P at midpoint btwn prev and current point (again)
    estIndividualsMid2 = estPopulation[i-1] + pPrime2 * deltaT/2
    # 3b. Estimate P' at midpoint btwn prev and current point (again)
    pPrime3 = estIndividualsMid2 * growthRate

    # 4a. Estimate P at current (right) point 
    estIndividualsRight = estPopulation[i-1] + pPrime3 * deltaT
    # 4b. Estimate P' at current (right) point
    pPrime4 = estIndividualsRight * growthRate

    # Weighted average of these P' values used as P' for whole interval
    estPopulation[i] = estPopulation[i-1] + (1/6) * 
      (pPrime + 2*pPrime2 + 2*pPrime3 + pPrime4) * deltaT

    # Compute the true analytical answer so we can see how off we were.
    truePopulation[i] = initialPopulation * exp(growthRate * x[i])
}


error = abs(estPopulation - truePopulation)
cat("We misunderestimated by", max(error), "individuals.\n")
plot(x,estPopulation,type="l",col="red")
lines(x,truePopulation,col="blue",type="l")
