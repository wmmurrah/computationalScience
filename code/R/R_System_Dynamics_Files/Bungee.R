
# Simulation of bungee cord jump
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 4.2
# R solution by Stephen Davies, University of Mary Washington

# Set up our time increment and our vector (array) of x (time) values
deltaX = .01   # s
x = seq(0,2*60,deltaX)

# Constants
springConstant = 6      # N/m
unweightedLength = 30   # m
accelGrav = -9.8        # m/s^2
mass = 80               # kg
projectedArea = .1      # m^2
weight = mass * accelGrav   # kg-m/s^2 (=N)

# Set up our stock variables and initial conditions. Note that "length" is
#   the length of the bungee cord, NOT the height/altitude of the jumper.
#   Hence if length increases, this indicates a descent, not an ascent.
length = vector(length=length(x))
length[1] = 0
velocity = vector(length=length(x))
velocity[1] = 0

# Loop a standard number of times, starting with i=2 since we've already
# set up the simulation's initial conditions at i=1.
for (i in 2:length(x)) {
    airFriction = -.65 * projectedArea * velocity[i-1] * abs(velocity[i-1])
    if (length[i-1] > unweightedLength) {
        restoringSpringForce = 
            springConstant * (length[i-1] - unweightedLength)
    } else {
        restoringSpringForce = 0
    }
    totalForce = weight + restoringSpringForce + airFriction
    acceleration = totalForce / mass
    velocityPrime = acceleration
    velocity[i] = velocity[i-1] + velocityPrime * deltaX
    lengthPrime = -velocity[i-1]
    length[i] = length[i-1] + lengthPrime * deltaX
}

plot(x,length,type="l",xlab="time (s)",ylab="length of bungee cord",col="blue")
