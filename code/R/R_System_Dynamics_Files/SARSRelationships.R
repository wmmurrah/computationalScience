
# Simulation of SEIR disease transmission model (for SARS epidemic)
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 6.2
# R solution by Stephen Davies, University of Mary Washington

# Set up our time increment and our vector (array) of x (time) values
deltaX = .01            # days
x = seq(0,4,deltaX)

# Constants
N0 = 1000000            # people (total size of population)
b =  0.0001             # unitless (prob. of transmission)
k = 10                  # people/day (contacts per day, indep of pop size)
m = .1                  # 1/day (SARS deaths per infected person per day)
p = 0.2                 # 1/day (new infections per exposed person per day)
q = .0001               # 1/day (exposed individuals quarantined per day)
u = .1                  # 1/day (quarantined individuals leaving per day)
v = 0.0625              # 1/day (recoveries per infection per day)
w = 0.0375              # 1/day (undetected infections detected per day)
w2 = w                  # 1/day (quarantined infectees isolated per day)
initInfected = 1        # people (initially infected and undetected)


# Set up our stock variables and initial conditions.
S = vector(length=length(x))
S[1] = N0 - initInfected
SQ = vector(length=length(x))
SQ[1] = 0
E = vector(length=length(x))
E[1] = 0
EQ = vector(length=length(x))
EQ[1] = 0
IU = vector(length=length(x))
IU[1] = initInfected
IQ = vector(length=length(x))
IQ[1] = 0
ID = vector(length=length(x))
ID[1] = 0
D = vector(length=length(x))
D[1] = 0
R = vector(length=length(x))
R[1] = 0


# Loop a standard number of times, starting with i=2 since we've already
# set up the simulation's initial conditions at i=1.
for (i in 2:length(x)) {

    # Compute rates of change (in people per day) for each of the
    #   categories. (We're just using Euler's method here: compute just one
    #   'prime' value for the far-left point of the interval.)

    Sprime = SQ[i-1] * u -
        S[i-1] *   q   * (k/N0) * (1-b) * IU[i-1] * S[i-1] -
        S[i-1] * (1-q) * (k/N0) *   b *   IU[i-1] * S[i-1] -
        S[i-1] *   q   * (k/N0) *   b *   IU[i-1] * S[i-1]

    SQprime = S[i-1] * q * (k/N0) * (1-b) * IU[i-1] * S[i-1] -
        SQ[i-1] * u

    Eprime = S[i-1] * (1-q) * (k/N0) *   b *   IU[i-1] * S[i-1] -
        E[i-1] * p

    EQprime = S[i-1] *   q   * (k/N0) *   b *   IU[i-1] * S[i-1] -
        EQ[i-1] * p

    IUprime = E[i-1] * p -
        IU[i-1] * v -
        IU[i-1] * w -
        IU[i-1] * m

    IQprime = EQ[i-1] * p -
        IQ[i-1] * w2 -
        IQ[i-1] * m -
        IQ[i-1] * v

    IDprime = IU[i-1] * w +
        IQ[i-1] * w2 -
        ID[i-1] * m -
        ID[i-1] * v

    Dprime = IQ[i-1] * m +
        IU[i-1] * m +
        ID[i-1] * m

    Rprime = IU[i-1] * v +
        ID[i-1] * v +
        IQ[i-1] * v

    # Increase or decrease the population of each category based on
    #   the rates of change for this time step.
    S[i] = S[i-1] + (Sprime) * deltaX
    SQ[i] = SQ[i-1] + (SQprime) * deltaX
    E[i] = E[i-1] + (Eprime) * deltaX
    EQ[i] = EQ[i-1] + (EQprime) * deltaX
    IU[i] = IU[i-1] + (IUprime) * deltaX
    IQ[i] = IQ[i-1] + (IQprime) * deltaX
    ID[i] = ID[i-1] + (IDprime) * deltaX
    D[i] = D[i-1] + (Dprime) * deltaX
    R[i] = R[i-1] + (Rprime) * deltaX
}

plot(x,S,type="n",xlab="time (days)",ylab="population",ylim=c(0,N0))
values = cbind(S,SQ,E,EQ,IU,IQ,R)
legendNames = c("susceptible","susceptible quarantined","exposed","exposed quarantined","infectious undetected","infectious quarantined","recovered")
lineTypes = c("solid","dashed","solid","dashed","solid","dashed","solid")
lineColors = c("black","black","blue","blue","red","red","green")

for (i in 1:ncol(values)) {
    lines(x,values[,i],lwd=2,lty=lineTypes[i],col=lineColors[i])
}
legend(x="topright", legend=legendNames, lty=lineTypes, lwd=2, col=lineColors)
