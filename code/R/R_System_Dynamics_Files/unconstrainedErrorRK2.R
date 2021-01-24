
# Simulation of unconstrained growth, along with exact value and relative
#   error using Runge-Kutta 2 method
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 5.2
# R solution by Stephen Davies, University of Mary Washington

# Compare the output of this program with:
#    unconstrainedErrorEuler.R and 
#    unconstrainedErrorRK4.R 
# and see how they compare for various values of deltaT. It's amazing!

deltaT = 1
simLength = 100
initialPopulation = 100
x = seq(0,100,deltaT)

growthRate = .1

# The "estPopulation" vector will store the values the RK2 method predicts
# for the population at each time step. Since this is a very simple
# function that has a known analytical solution, "truePopulation" will be
# used to store the actual, exact population. (Note that computing the
# actual, exact population like this is only possible under very restricted
# circumstances, when the differential equation is simple enough to be
# solved analytically.)
# We can compare the two to see how far off RK2 is from the true answer.
estPopulation = vector(length=length(x))
estPopulation[1] = initialPopulation
truePopulation = vector(length=length(x))
truePopulation[1] = initialPopulation

for (i in 2:length(x)) {

    # Compute P' at the previous clock tick (i.e., the far left end of the
    # interval whose right-hand side we are estimating.)
    pPrimeLeft = estPopulation[i-1] * growthRate

    # Let's use that far-left P' value to estimate how many individuals there
    # will be at the far-right side of the interval. Sure, we're wrong, but
    # this will enable us to guess at what P' will be at the right-hand
    # side, and then average the left and right sides.
    estIndividualsRight = estPopulation[i-1] + pPrimeLeft * deltaT

    # Suppose we were right about our estIndividualsRight guess. What
    # would be the growth rate at that right-most point, then?
    estPPrimeRight = estIndividualsRight * growthRate

    # This is our final answer: we'll average our left (true) and right
    # (estimated) P' numbers to approximate the slope over the entire
    # interval.
    estPopulation[i] = estPopulation[i-1] + 
        (pPrimeLeft + estPPrimeRight) / 2 * deltaT

    # Compute the true analytical answer so we can see how off we were.
    truePopulation[i] = initialPopulation * exp(growthRate * x[i])
}


error = abs(estPopulation - truePopulation)
cat("We misunderestimated by", max(error), "individuals.\n")
plot(x,estPopulation,type="l",col="red")
lines(x,truePopulation,col="blue",type="l")
