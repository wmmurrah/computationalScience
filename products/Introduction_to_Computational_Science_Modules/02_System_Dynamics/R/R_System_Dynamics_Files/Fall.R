
# Simulation of fall of ball
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 4.1, example 1, p.115
# R solution by Stephen Davies, University of Mary Washington

# Set up our time increment and our vector (array) of x (time) values
deltaX = 0.01                   # s
x = seq(0,4,deltaX)             # s

# Constants
accelGrav = -9.8                # m/s^2

# Set up our stock variables and initial conditions
velocity = vector(length=length(x))
velocity[1] = 15    # m/s
position = vector(length=length(x))
position[1] = 11    # m


# Loop a standard number of times, starting with i=2 since we've already
# set up the simulation's initial conditions at i=1.
for (i in 2:length(x)) {
    velocity[i] = velocity[i-1] + accelGrav * deltaX
    positionPrime = velocity[i-1]
    position[i] = position[i-1] + positionPrime * deltaX
}

speed = abs(velocity)

par(mfrow=c(2,1))
plot(x,position,type="l",col="black",lwd=2)
plot(x,speed,type="l",col="blue",lwd=2)
