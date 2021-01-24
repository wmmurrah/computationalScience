
# Skydive simulation
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 4.1, example 3, p.122
# R solution by Stephen Davies, University of Mary Washington

# Set up our time increment and our vector (array) of x (time) values
deltaX = 0.01               # s
x = seq(0,5*60,deltaX)      # s

# Constants
accelGrav = -9.8            # m/s^2
mass = 150/2.2              # kg (150-lb. person)
positionOpen = 1000         # m (the altitude to pull ripcord)
weight = mass * accelGrav   # kg-m/s^2  (N)

# Set up our stock variables and initial conditions
velocity = vector(length=length(x))
velocity[1] = 0    # m/s
position = vector(length=length(x))
position[1] = 2000 # m

# Convenience functions to translate from x (a time in seconds) to i (an
# index into the stock variable vectors) and vice versa
xtoi = function(x) x/deltaX + 1
itox = function(i) (i-1) * deltaX


# Loop a standard number of times, starting with i=2 since we've already
# set up the simulation's initial conditions at i=1.
for (i in 2:length(x)) {
    if (position[i-1] < positionOpen) {
        projectedArea = 28  # m^2 -- open chute
    } else {
        projectedArea = .4  # m^2 -- closed chute
    }
    airFriction = -.65 * projectedArea * velocity[i-1] * abs(velocity[i-1])
    totalForce = airFriction + weight
    acceleration = totalForce / mass   # F=ma
    velocityPrime = acceleration
    velocity[i] = velocity[i-1] + acceleration * deltaX
    positionPrime = velocity[i-1]
    position[i] = max(0,position[i-1] + positionPrime * deltaX)
}

speed = abs(velocity)

plot(x,position,type="l")

cat("You touched down at", itox(which(position<=0)[1]),"seconds\n")
cat("You hit the ground at", speed[which(position<=0)[1]], "m/s\n")
cat("You hit the ground at", (speed[which(position<=0)[1]]*2.2), "mph\n")
