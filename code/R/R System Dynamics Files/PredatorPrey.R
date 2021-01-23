
# Simulation of squirrel-hawk (predator-prey) interaction
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 6.4
# R solution by Stephen Davies, University of Mary Washington

# Set up our time increment and our vector (array) of x (time) values
deltaX = .01   # months
x = seq(0,12,deltaX)

# Constants
ks = 2       # 1/month (prey birth fraction)
khs = 0.02       # 1/month (prey death proportionality constant)
ksh = 0.01       # 1/month (predator birth fraction)
kh = 1.06       # 1/month (predator death proportionality constant)
initS = 100       # squirrels
initH = 15       # hawks


# Set up our stock variables and initial conditions.
S = vector(length=length(x))
S[1] = initS
H = vector(length=length(x))
H[1] = initH

# Loop a standard number of times, starting with i=2 since we've already
# set up the simulation's initial conditions at i=1.
for (i in 2:length(x)) {

    # Compute rates of change (in animals per day) for each species.
    #   (We're doing RK2 here.)
    Sprime = ks * S[i-1] - khs * S[i-1] * H[i-1]
    Hprime = ksh * S[i-1] * H[i-1] - kh * H[i-1]
    estSRight = S[i-1] + (Sprime) * deltaX
    estHRight = H[i-1] + (Hprime) * deltaX
    Sprime2 = ks * estSRight - khs * estSRight * estHRight
    Hprime2 = ksh * estSRight * estHRight - kh * estHRight
    Sprime = (Sprime + Sprime2) / 2
    Hprime = (Hprime + Hprime2) / 2

    # Increase or decrease the population of each category based on
    #   the rates of change for this time step.
    S[i] = S[i-1] + (Sprime) * deltaX
    H[i] = H[i-1] + (Hprime) * deltaX
}

par(mfrow=c(2,1))   # This command states that the graphics window will 
                    # contain *two* plots, one on top of the other. (The
                    # argument is a vector of dimensions: in this case, 
                    # the plots will be two rows of one column each.)
plot(x,S,type="n",xlab="time (months)",ylab="population")
legend("topright", legend=c("prey","predators"), lty=c("dotted","solid"))
lines(x,S,lwd=2,lty="dotted")
lines(x,H,lwd=2,lty="solid")
plot(S,H,type="l",lwd=2,lty="solid",xlab="prey",ylab="predators")
