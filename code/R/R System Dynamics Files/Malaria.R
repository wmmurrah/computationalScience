
# Simulation of malaria outbreak
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 6.5
# R solution by Stephen Davies, University of Mary Washington

# Set up our time increment and our vector (array) of x (time) values
deltaX = .01   # day
x = seq(0,1500,deltaX)

# Constants
probBit = 0.3           # 1/day (daily probability of being bitten by mosq)
recoveryRate = 0.3      # 1/day (daily probability of human recovering)
immunityRate = 0.01     # 1/day (daily probability of human becoming immune)
malDeathRate = 0.005    # 1/day (daily probability of human dying)
probBiteHuman = 0.3     # 1/day (daily probability of biting a human)
mosqBirthRate = 0.01    # 1/day (mosquitos born per mosquito per day)
mosqDeathRate = 0.01    # 1/day (daily probability of mosquito dying)
recoveryRate = .3       # 1/day
initUninfHumans = 300   # humans (number of uninfected humans)
initHumanHosts = 1      # humans (number of people infected)
initImmune = 0          # humans (number of people recovered and immune)
initUninfMosq = 300     # mosquitos (number of uninfected mosquitos)
initVectors = 0         # mosquitos (number of infected mosquitos)

# Set up our stock variables and initial conditions.
UninfHumans = vector(length=length(x))
UninfHumans[1] = initUninfHumans
HumanHosts = vector(length=length(x))
HumanHosts[1] = initHumanHosts
Immune = vector(length=length(x))
Immune[1] = initImmune
UninfMosq = vector(length=length(x))
UninfMosq[1] = initUninfMosq
Vectors = vector(length=length(x))
Vectors[1] = initVectors

# Loop a standard number of times, starting with i=2 since we've already
# set up the simulation's initial conditions at i=1.
for (i in 2:length(x)) {

    totalMosquitos = Vectors[i-1] + UninfMosq[i-1]
    totalHumans = UninfHumans[i-1] + HumanHosts[i-1] + Immune[i-1]

    # Compute rates of change.
    UninfHumansPrime = HumanHosts[i-1] * recoveryRate -
        UninfHumans[i-1] * probBit * Vectors[i-1] / totalMosquitos

    HumanHostsPrime = 
        UninfHumans[i-1] * probBit * Vectors[i-1] / totalMosquitos - 
        HumanHosts[i-1] * recoveryRate -
        HumanHosts[i-1] * malDeathRate -
        HumanHosts[i-1] * immunityRate
    
    ImmunePrime = HumanHosts[i-1] * immunityRate

    UninfMosqPrime = totalMosquitos * mosqBirthRate -
        UninfMosq[i-1] * mosqDeathRate -
        UninfMosq[i-1] * probBiteHuman * HumanHosts[i-1] / totalHumans

    VectorsPrime = 
        UninfMosq[i-1] * probBiteHuman * HumanHosts[i-1] / totalHumans -
        Vectors[i-1] * mosqDeathRate

    # Increase or decrease the population of each category based on
    #   the rates of change for this time step. (Euler's method.)
    UninfHumans[i] = UninfHumans[i-1] + UninfHumansPrime * deltaX
    HumanHosts[i] = HumanHosts[i-1] + HumanHostsPrime * deltaX
    Immune[i] = Immune[i-1] + ImmunePrime * deltaX
    UninfMosq[i] = UninfMosq[i-1] + UninfMosqPrime * deltaX
    Vectors[i] = Vectors[i-1] + VectorsPrime * deltaX
}


plot(x,UninfHumans,type="n",xlab="time (days)",ylab="population",
    ylim=c(0,400))
lines(x,UninfHumans,lwd=2,col="blue",lty="dashed")
lines(x,HumanHosts,lwd=2,col="blue",lty="solid")
lines(x,Immune,lwd=2,col="green",lty="solid")
lines(x,UninfMosq,lwd=2,col="black",lty="dashed")
lines(x,Vectors,lwd=2,col="black",lty="solid")

legend(x="topright",legend=c("uninfected humans","human hosts","immune humans","uninfected mosquitos","mosquito vectors"),lty=c("dashed","solid","solid","dashed","solid"),col=c("blue","blue","green","black","black"),lwd=2)
