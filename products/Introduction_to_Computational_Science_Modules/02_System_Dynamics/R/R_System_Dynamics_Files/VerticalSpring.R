
# Simulation of undamped vertical spring
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 4.2
# R solution by Stephen Davies, University of Mary Washington

# Set up our time increment and our vector (array) of x (time) values
deltaX = .001   # s
x = seq(0,30,deltaX)

# Constants
initDisplacement = .3       # m
springConstant = 10         # N/m
unweightedLength = 1        # m
accelGrav = 9.8             # m/s^2
mass = .2                   # kg
weight = mass * accelGrav   # kg-m/s^2 (=N)
weightDisplacement = weight / springConstant

# Set up our stock variables and initial conditions.
length = vector(length=length(x))
length[1] = unweightedLength + weightDisplacement + initDisplacement
velocity = vector(length=length(x))
velocity[1] = 0

# Loop a standard number of times, starting with i=2 since we've already
# set up the simulation's initial conditions at i=1.
for (i in 2:length(x)) {
    lengthPrime = velocity[i-1]
    length[i] = length[i-1] + lengthPrime * deltaX
    restoringSpringForce = -springConstant * (length[i] - unweightedLength)
    totalForce = weight + restoringSpringForce
    acceleration = totalForce / mass
    velocityPrime = acceleration
    velocity[i] = velocity[i-1] + velocityPrime * deltaX
}

plot(x,length,type="l",xlab="time (s)",ylab="length of spring (m)",col="blue")
