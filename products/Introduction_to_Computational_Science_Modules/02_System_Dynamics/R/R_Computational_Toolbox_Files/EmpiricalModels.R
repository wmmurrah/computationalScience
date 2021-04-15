# Models for Module 8.3 on "Empirical Models"
# File: EmpiricalModels.R
# Introduction to Computational Science -- Shiflet & Shiflet
# Module 10.3
# Introduction to Computational Science:
# Modeling and Simulation for the Sciences, 2nd Edition
# Angela B. Shiflet and George W. Shiflet
# Wofford College
# © 2014 by Princeton University Press
#
# R solution by Stephen Davies, University of Mary Washington

###
# Linear Empirical Model
# Figure 8.3.1
xLst = c(0.2, 0.4, 0.3, 0.3)
yLst = c(0.1, 0.3, 0.3, 0.6)
data = data.frame(xLst=xLst,yLst=yLst)
plot(xLst, yLst, pch=19)  # (pch=19 gives a filled-in circle.)

# Figure 8.3.2
bestline = lm(yLst ~ xLst, data=data)
x = seq(0,.6,.1)
lineValues = bestline$coefficients %*% rbind(1,x)
lines(x, lineValues, type="l", col="blue", lwd=2)

# Predictions
x = 0.34
predictedY = bestline$coefficients %*% rbind(1,x)
cat("Predicted value at x=",x," is ", predictedY, "\n", sep="")
points(x, predictedY, col="green")
cat("Figure 8.3.2: four data points, and the best-fit line.\n")
cat("(A predicted value in green.)\n")
readline("Press RETURN for next plot.")

###
# Non-Linear One-Term Model

# Figure 8.3.5
xLst = c(1.309, 1.471, 1.490, 1.565, 1.611, 1.680)
yLst = c(2.138, 3.421, 3.597, 4.340, 4.882, 5.660)
data = data.frame(xLst=xLst,yLst=yLst)
plot(xLst, yLst, col="black", pch=19)
segments(xLst[1], yLst[1], xLst[6], yLst[6], col="gray")

cat("Figure 8.3.5: DanWood data set, non-transformed.\n")
cat("(Thin gray line connects the two endpoints directly.)\n")
readline("Press RETURN for next plot.")

# Figure 8.3.6
plot(xLst^2, yLst, col="black", pch=19)
segments(xLst[1]^2, yLst[1], xLst[6]^2, yLst[6], col="gray")

cat("Figure 8.3.6: DanWood data set, quadratically transformed.\n")
cat("(Thin gray line connects the two endpoints directly.)\n")
readline("Press RETURN for next plot.")

# Figure 8.3.7
plot(xLst^3, yLst, col="black", pch=19)
segments(xLst[1]^3, yLst[1], xLst[6]^3, yLst[6], col="gray")

cat("Figure 8.3.7: DanWood data set, cubically transformed.\n")
cat("(Thin gray line connects the two endpoints directly.)\n")
readline("Press RETURN for next plot.")

# Figure 8.3.8
plot(xLst^4, yLst, col="black", pch=19)
segments(xLst[1]^4, yLst[1], xLst[6]^4, yLst[6], col="gray")

cat("Figure 8.3.8: DanWood data set, quartically transformed.\n")
cat("(Thin gray line connects the two endpoints directly.)\n")
readline("Press RETURN for next plot.")

# Figure 8.3.9
plot(xLst^3.5, yLst, col="black", pch=19)
segments(xLst[1]^3.5, yLst[1], xLst[6]^3.5, yLst[6], col="gray")

cat("Figure 8.3.9: DanWood data set, transformed according to x^3.5.\n")
cat("(Thin gray line connects the two endpoints directly.)\n")
readline("Press RETURN for next plot.")

# Figure 8.3.10
plot(xLst^3.5, yLst, col="black", pch=19)
segments(xLst[1]^3.5, yLst[1], xLst[6]^3.5, yLst[6], col="gray")

bestline = lm(yLst ~ I(xLst^3.5), data=data)
x = seq(1.3^3.5,1.7^3.5,0.1)
lineValues = bestline$coefficients %*% rbind(1,x)
lines(x, lineValues, type="l", col="blue", lwd=2)

cat("Figure 8.3.10: DanWood data set, with best-fit linear regression line\n")
cat("in the transformed space.\n")
readline("Press RETURN for next plot.")

# Figure 8.3.11
plot(xLst, yLst, xlim=c(0,1.75), ylim=c(-1,6), col="black", pch=19)

bestline = lm(yLst ~ I(xLst^3.5), data=data)
x = seq(0,1.75,.05)
lineValues = bestline$coefficients %*% rbind(1,x^3.5)
lines(x, lineValues, type="l", col="blue", lwd=2)

cat("Figure 8.3.11: DanWood data set, with best-fit linear regression line\n")
cat("through the original set of points.\n")
readline("Press RETURN for next plot.")


###
# Solving for y in a One-Term Model
xLst = c(77.6, 114.9, 141.1, 190.8, 239.9, 289.0, 332.8, 378.4, 434.8,
    477.3, 536.8, 593.1, 689.1, 760.0)
yLst = c(10.07, 14.73, 17.94, 23.93, 29.61, 35.18, 40.02, 44.82, 50.76,
    55.05, 61.01, 66.40, 75.47, 81.78)
data = data.frame(xLst=xLst,yLst=yLst)

# Figure 8.3.13
plot(xLst, yLst, col="black", pch=19)
segments(xLst[1], yLst[1], xLst[length(xLst)], yLst[length(xLst)],
    col="gray")

cat("Figure 8.3.13: Dental data set, non-transformed.\n")
cat("(Thin gray line connects the two endpoints directly.)\n")
readline("Press RETURN for next plot.")

# Figure 8.3.14
plot(xLst, yLst^(6/5), col="black", pch=19)
segments(xLst[1], yLst[1]^(6/5), xLst[length(xLst)],
    yLst[length(xLst)]^(6/5), col="gray")
bestline = lm(I(yLst^(6/5)) ~ xLst, data=data)
x = seq(50,800,1)
lineValues = bestline$coefficients %*% rbind(1,x)
lines(x, lineValues, type="l", col="blue", lwd=2)

cat("Figure 8.3.14: Dental data set, non-transformed.\n")
cat("(Thin gray line connects the two endpoints directly.)\n")
readline("Press RETURN for next plot.")

# Figure 8.3.15
plot(xLst, yLst, col="black", pch=19)

bestline = lm(I(yLst^(6/5)) ~ xLst, data=data)
x = seq(50,800,1)
lineValues = bestline$coefficients %*% rbind(1,x)
lines(x, lineValues^(5/6), type="l", col="blue", lwd=2)

cat("Figure 8.3.15: Dental data set, with best-fit linear regression line\n")
cat("through the original set of points.\n")
readline("Press RETURN for next plot.")


###
# Multi-term Models
xLst = c(-6.860120914, -4.324130045, -4.358625055, -4.358426747,
    -6.955852379, -6.661145254, -6.355462942, -6.118102026, -7.115148017,
    -6.815308569, -6.519993057, -6.204119983, -5.853871964, -6.109523091,
    -5.79832982, -5.482672118, -5.171791386, -4.851705903, -4.517126416,
    -4.143573228, -3.709075441, -3.499489089, -6.300769497, -5.953504836,
    -5.642065153, -5.031376979, -4.680685696, -4.329846955, -3.928486195,
    -8.56735134, -8.363211311, -8.107682739, -7.823908741, -7.522878745,
    -7.218819279, -6.920818754, -6.628932138, -6.323946875, -5.991399828,
    -8.781464495, -8.663140179, -8.473531488, -8.247337057, -7.971428747,
    -7.676129393, -7.352812702, -7.072065318, -6.774174009, -6.478861916,
    -6.159517513, -6.835647144, -6.53165267, -6.224098421, -5.910094889,
    -5.598599459, -5.290645224, -4.974284616, -4.64454848, -4.290560426,
    -3.885055584, -3.408378962, -3.13200249, -8.726767166, -8.66695597,
    -8.511026475, -8.165388579, -7.886056648, -7.588043762, -7.283412422,
    -6.995678626, -6.691862621, -6.392544977, -6.067374056, -6.684029655,
    -6.378719832, -6.065855188, -5.752272167, -5.132414673, -4.811352704,
    -4.098269308, -3.66174277, -3.2644011)
yLst = c(0.8116, 0.9072, 0.9052, 0.9039, 0.8053, 0.8377, 0.8667, 0.8809,
    0.7975, 0.8162, 0.8515, 0.8766, 0.8885, 0.8859, 0.8959, 0.8913, 0.8959,
    0.8971, 0.9021, 0.909 , 0.9139, 0.9199, 0.8692, 0.8872, 0.89  , 0.891 ,
    0.8977, 0.9035, 0.9078, 0.7675, 0.7705, 0.7713, 0.7736, 0.7775, 0.7841,
    0.7971, 0.8329, 0.8641, 0.8804, 0.7668, 0.7633, 0.7678, 0.7697, 0.77  ,
    0.7749, 0.7796, 0.7897, 0.8131, 0.8498, 0.8741, 0.8061, 0.846 , 0.8751,
    0.8856, 0.8919, 0.8934, 0.894 , 0.8957, 0.9047, 0.9129, 0.9209, 0.9219,
    0.7739, 0.7681, 0.7665, 0.7703, 0.7702, 0.7761, 0.7809, 0.7961, 0.8253,
    0.8602, 0.8809, 0.8301, 0.8664, 0.8834, 0.8898, 0.8964, 0.8963, 0.9074,
    0.9119, 0.9228)
data = data.frame(xLst=xLst,yLst=yLst)

# Figure 8.3.16
plot(xLst, yLst, col="black", pch=19)
cat("Figure 8.3.16: Filippelli data set.\n")
readline("Press RETURN for next plot.")

# Figure 8.3.17
# There are two ways to do more complex polynomials. One is to explicitly
# build a model with all of the terms (the first-order term, the squared
# term, the cubic term, etc.) Here's an example:
bestquartic = lm(yLst ~ I(xLst) +
    I(xLst^2) +
    I(xLst^3) +
    I(xLst^4), data=data)
x = seq(min(xLst), max(xLst), .1)
# Note that we're getting back FIVE coefficients now instead of just two
# with the linear model, so we need to matrix multiply them by all five of
# the terms that they go with.
lineValues = bestquartic$coefficients %*% rbind(1,x,x^2,x^3,x^4)
lines(x, lineValues, type="l", col="blue", lwd=2)

cat("Figure 8.3.17: Filippelli data set, with best-fit quartic.\n")
readline("Press RETURN for next plot.")

# Figure 8.3.16
# The other way to do it is to use the "poly()" function to create a model
# (here, 10th degree), and then use the "predict()" function, passing it a
# data frame with a column of the proper name, to get the points. Here's an
# example:
plot(xLst, yLst, col="black", pch=19)

besttenth = lm(yLst ~ poly(xLst,10), data=data)
x = seq(min(xLst), max(xLst), .1)
lines(x, predict(besttenth, data.frame(xLst=x)), type="l", col="blue", lwd=2)

cat("Figure 8.3.18: Filippelli data set, with best-fit 10th-order polynomial.\n")
readline("Press RETURN for next plot.")
