
# Simulation of shark competition
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 6.1
# R solution by Stephen Davies, University of Mary Washington

# Set up our time increment and our vector (array) of x (time) values
deltaX = .01   # month
x = seq(0,5,deltaX)

# Constants
WTSbirthFraction = 1    # 1/month (WTS births per WTS adult per month)
BTSbirthFraction = 1    # 1/month (BTS births per BTS adult per month)
WTSdeathConstant = .27  # 1/BTS*month (WTS deaths per WTS per BTS per mo.)
BTSdeathConstant = .20  # 1/WTS*month (BTS deaths per BTS per WTS per mo.)
initBTSpop = 15         # sharks
initWTSpop = 20         # sharks

# Set up our stock variables and initial conditions. BTSpop is the number
#   of black-tip sharks at each time step, and WTSpop the number of white-
#   tip sharks.
BTSpop = vector(length=length(x))
BTSpop[1] = initBTSpop
WTSpop = vector(length=length(x))
WTSpop[1] = initWTSpop

# Loop a standard number of times, starting with i=2 since we've already
# set up the simulation's initial conditions at i=1.
for (i in 2:length(x)) {

    # Compute births/month and deaths/month for each type of shark.
    WTSbirthRate = WTSbirthFraction * WTSpop[i-1]
    BTSbirthRate = BTSbirthFraction * BTSpop[i-1]
    WTSdeathRate = WTSdeathConstant * WTSpop[i-1] * BTSpop[i-1]
    BTSdeathRate = BTSdeathConstant * BTSpop[i-1] * WTSpop[i-1]

    # Increase or decrease the population of each type of shark based on
    #   the birth and death rates for this time step.
    WTSpop[i] = WTSpop[i-1] + (WTSbirthRate - WTSdeathRate) * deltaX
    BTSpop[i] = BTSpop[i-1] + (BTSbirthRate - BTSdeathRate) * deltaX
}

plot(x,WTSpop,type="n",xlab="time (months)",ylab="population",ylim=c(0,28))
lines(x,WTSpop,lwd=2,lty="solid")
lines(x,BTSpop,lwd=1,lty="dashed")
text(3.5,9,"BTS")
text(4,2,"WTS")
