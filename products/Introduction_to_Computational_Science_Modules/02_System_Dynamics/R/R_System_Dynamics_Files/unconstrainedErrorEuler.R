
# Simulation of unconstrained growth, along with exact value and relative
#   error using Euler's method
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 5.2
# R solution by Stephen Davies, University of Mary Washington

# Compare the output of this program with:
#    unconstrainedErrorRK2.R and 
#    unconstrainedErrorRK4.R 
# and see how much better they are for various values of deltaT. It's
# amazing!

deltaT = 1
simLength = 100
initialPopulation = 100
x = seq(0,100,deltaT)

growthRate = .1

# The "estPopulation" vector will store the values Euler's method predicts
# for the population at each time step. Since this is a very simple
# function that has a known analytical solution, "truePopulation" will be
# used to store the actual, exact population. (Note that computing the
# actual, exact population like this is only possible under very restricted
# circumstances, when the differential equation is simple enough to be
# solved analytically.)
# We can compare the two to see how far off Euler's method is from the true
# answer.
estPopulation = vector(length=length(x))
estPopulation[1] = initialPopulation
truePopulation = vector(length=length(x))
truePopulation[1] = initialPopulation

for (i in 2:length(x)) {

    # Compute P' at the previous clock tick (i.e., the far left end of the
    # interval whose right-hand side we are estimating.)
    estPPrimeLeft = estPopulation[i-1] * growthRate

    # Euler's method: heck, just use that far left P' and assume it was the
    # growth rate across the entire interval.
    estPopulation[i] = estPopulation[i-1] + estPPrimeLeft * deltaT

    # Compute the true analytical answer so we can see how off we were.
    truePopulation[i] = initialPopulation * exp(growthRate * x[i])
}

error = abs(estPopulation - truePopulation)
cat("We misunderestimated by", max(error), "individuals.\n")
plot(x,estPopulation,type="l",col="red")
lines(x,truePopulation,col="blue",type="l")
