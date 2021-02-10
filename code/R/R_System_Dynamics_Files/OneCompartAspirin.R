
# Simple one-compartment, single-dose aspirin simulation.
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 3.5, example 1, p.99
# R solution by Stephen Davies, University of Mary Washington

# problem parameters from diagram
tabletSize = 325     # mg
halfLife = 3.2       # hr

# other problem parameters for convenience and flexibility
numAspirin = 2
plasmaVolume = 3000  # ml
mec = 150            # min effective concentration (ug/ml)
mtc = 350            # max therapeutic concentration (ug/ml)

# simulation parameters
simulationHours = 8  # hr
deltaX = 5/60        # hr
x = seq(0,simulationHours,deltaX)

# determine elimination constant
eliminationConstant = -log(0.5)/halfLife   # 1/hr

# set up 'box variable' vector
aspirinInPlasma = vector()
aspirinInPlasma[1] = numAspirin * tabletSize * 1000   # ug

# run simulation for the correct number of clock ticks
for (i in 2:length(x)) {

    # for this clock tick, determine how much aspirin is eliminated. note
    # that since eliminationConstant is in "per hours," we must divide by
    # 60 to get "per minutes." 
    elimination = (aspirinInPlasma[i-1] * eliminationConstant) * deltaX
    aspirinInPlasma[i] = aspirinInPlasma[i-1] - elimination
}

plasmaConcentration = aspirinInPlasma / plasmaVolume   # ug/ml

plot(
    x = x,

    # we're plotting the concentration, not the raw amount of aspirin.
    y = plasmaConcentration,

    type = "l",
    xlab = "hours",
    ylab = "plasma concentration (ug/ml)",
    ylim = c(0,500),  # min and max of y-axis
    main = "Aspirin concentration over time")

# plot a line to show the minimum effective concentration (MEC)
abline(mec,0,col="blue")

# plot a line to show the maximum therapeutic concentration (MTC)
abline(mtc,0,col="red")
