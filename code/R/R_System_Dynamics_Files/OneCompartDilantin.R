
# One-compartment, multiple-dose dilantin simulation.
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 3.5, example 2, p.101
# R solution by Stephen Davies, University of Mary Washington

# problem parameters from diagram
mec = 10                    # ug/ml
mtc = 20                    # ug/ml
halfLife = 22               # hr
volume = 3000               # ml
dosage = 100 * 1000         # ug
absorptionFraction = 0.12   # (unitless)
interval = 8                # hr

# simulation parameters
simHrs = 168                # hr
deltaX = 2/60               # hr
x = seq(0,simHrs,deltaX)

# convenience functions to convert between x (time) and i (index) values
xtoi = function(x) x/deltaX + 1
itox = function(i) (i-1)*deltaX

# determine elimination constant
eliminationConstant = -log(0.5)/halfLife   # 1/hr

# set up 'box variable' vector
drugInSystem = vector()   # ug
drugInSystem[1] = absorptionFraction * dosage

# run simulation for the correct number of clock ticks
for (i in 2:length(x)) {

    # if exactly an even multiple of "interval" hours has passed, simulate
    # the patient taking one dose. otherwise, ingest nothing this clock
    # tick.
    if (itox(i) %% interval == 0) {
        ingested = absorptionFraction * dosage
    } else {
        ingested = 0
    }

    # for this clock tick, determine how much dilantin is eliminated. note
    # that since eliminationConstant is in "per hours," we must divide by
    # 60 to get "per minutes." 
    eliminated = (eliminationConstant * drugInSystem[i-1]) * deltaX

    # update the value of the drug in system for the next instant in time.
    # it's equal to what it is during this instant, except that we increase
    # it by the amount ingested (if any), and decrease it by the amount
    # eliminated.
    drugInSystem[i] = drugInSystem[i-1] + ingested - eliminated
}

concentration = drugInSystem / volume

plot(
    x = x,
    y = concentration,
    type = "l",
    ylim = c(0,25),
    xlab = "hours",
    ylab = "concentration (ug/ml)",
    main = "Dilantin concentration over time")

# plot a line to show the minimum effective concentration (MEC)
abline(mec,0,col="blue")

# plot a line to show the maximum therapeutic concentration (MTC)
abline(mtc,0,col="red")
