
# Simulation of simple pendulum
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 4.3
# R solution by Stephen Davies, University of Mary Washington

# Set up our time increment and our vector (array) of x (time) values
deltaX = .001           # seconds
maxX = 6                # seconds
x = seq(0,maxX,deltaX)  # seconds

# Constants
initAngle = pi/4        # radians
l = 1                   # meters
accelGrav = -9.8        # meters/sec^2

# Set up our stock variables and initial conditions. Note that in the
# book's figure 4.3.2, angular acceleration is not a stock variable. We
# make it one here, however, so we can plot it and reproduce Figure 4.3.3.
angle = vector(length=length(x))                # radians
angle[1] = initAngle
angularVelocity = vector(length=length(x))      # radians/sec
angularVelocity[1] = 0
angularAcceleration = vector(length=length(x))  # radians/sec^2
angularAcceleration[1] = 0


# Loop a standard number of times, starting with i=2 since we've already
# set up the simulation's initial conditions at i=1.
for (i in 2:length(x)) {
    angularAcceleration[i] = accelGrav * sin(angle[i-1]) / l
    angularVelocity[i] = angularVelocity[i-1] + 
        angularAcceleration[i-1] * deltaX
    angle[i] = angle[i-1] + angularVelocity[i-1] * deltaX
}

plot(x,angle,type="l",col="blue",lwd=2,ylim=c(min(angularAcceleration),max(angularAcceleration)))
lines(x,angularVelocity,lwd=2,col="black")
lines(x,angularAcceleration,lwd=2,lty="dotted")
