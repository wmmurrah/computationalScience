library(crone)
n <- 10
t <- 0:65


v <- heaviside(n - t, 0) * (1 - exp(-.15*t)) + 
  heaviside(t - n, 0) * (1 - exp(-1.5)) * exp(-.15*(t - n))

plot(v ~ t, 
     type = "l", 
     ylim = c(0,1),
     yaxs = "i",
     ylab = "v",
     main = "Rescorla-Wagner Model in Step Funcion")
abline(v = n, col = "red")
