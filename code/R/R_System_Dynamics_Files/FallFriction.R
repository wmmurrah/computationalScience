
# Simulation of fall of ball -- including friction
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 4.1, example 2, p.120
# R solution by Stephen Davies, University of Mary Washington

# Set up our time increment and our vector (array) of x (time) values
deltaX = 0.01                   # s
x = seq(0,15,deltaX)            # s

# Constants
accelGrav = -9.8                # m/s^2
mass = 0.5                      # kg
radius = 0.05                   # m
weight = mass * accelGrav       # kg-m/s^2  (N)
projectedArea = pi * radius^2   # m^2

# Set up our stock variables and initial conditions
velocity = vector(length=length(x))
velocity[1] = 0    # m/s
position = vector(length=length(x))
position[1] = 400 # m


# Loop a standard number of times, starting with i=2 since we've already
# set up the simulation's initial conditions at i=1.
for (i in 2:length(x)) {
    airFriction = -.65 * projectedArea * velocity[i-1] * abs(velocity[i-1])
    totalForce = airFriction + weight
    acceleration = totalForce / mass   # F=ma
    velocityPrime = acceleration
    velocity[i] = velocity[i-1] + acceleration * deltaX
    positionPrime = velocity[i-1]
    position[i] = max(0,position[i-1] + positionPrime * deltaX)
}

speed = abs(velocity)

par(mfrow=c(2,1))
plot(x,position,type="l",col="black",lwd=2)
plot(x,speed,type="l",col="blue",lwd=2)
