
# Simulation of rocket
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 4.4
# R solution by Stephen Davies, University of Mary Washington

# Set up our time increment and our vector (array) of x (time) values
deltaX = .01            # seconds
maxX = 400               # seconds
x = seq(0,maxX,deltaX)  # seconds

# Constants
initialMass = 5000      # kg
rocketMass = 1000       # kg
burnoutTime = 60        # seconds
specificImpulse = 200   # seconds
accelGrav = -9.8        # meters/sec^2

# Set up our stock variables and initial conditions.
position = vector(length=length(x))     # meters (altitude)
position[1] = 0
velocity = vector(length=length(x))     # meters/sec
velocity[1] = 0
mass = vector(length=length(x))         # kg (total mass of rocket + fuel)
mass[1] = initialMass

# Convenience functions to translate from x (a time in seconds) to i (an
# index into the stock variable vectors) and vice versa
itox = function(i) (i-1) * deltaX
xtoi = function(x) x / deltaX + 1

# Loop a standard number of times, starting with i=2 since we've already
# set up the simulation's initial conditions at i=1.
for (i in 2:length(x)) {

    # Compute the change in mass for this clock tick. If we haven't yet
    # consumed all our fuel, then we lose a constant amount of mass (this
    # is equal to the initial amount of unburned fuel divided by the time
    # it would take to burn all of it.) If we have, then we're coasting
    # (and lose no more mass thereafter).
    if (itox(i) < burnoutTime) {
        changeInMass = -(initialMass - rocketMass) / burnoutTime
    } else {
        changeInMass = 0
    }

    # Since changeInMass is measured in kg/sec, we lose some number of kg
    # this clock tick, computed by multiplying this by our time interval.
    mass[i] = mass[i-1] + changeInMass * deltaX

    # The change in velocity has two components: gravity is pulling the
    # rocket down (duh), and the loss of fuel is propelling the rocket up.
    # Note that both accelGrav and changeInMass are negative here, which
    # means the second term of the equation below is positive.
    velocityPrime = accelGrav + 
        specificImpulse * accelGrav * changeInMass / mass[i-1]

    velocity[i] = velocity[i-1] + velocityPrime * deltaX

    position[i] = position[i-1] + velocity[i-1] * deltaX
}

# Note that we're plotting position and velocity on the same scale, below,
# which means that the velocity values are itsy bitsy (and the plot
# doesn't look exactly like Figure 4.4.2).
plot(x,position,type="l",col="blue",lwd=2,ylim=c(min(velocity),max(position)))
lines(x,velocity,lwd=2,col="black")
