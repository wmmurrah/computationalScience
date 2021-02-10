# RFunctionTutorialAns.R

#QRQ 1
t = seq(-3, 3, 0.1)
plot(t, 2*t + 1, type = "l")
lines(t, 2*t + 3, col="green", lty="dashed")
# Moves graph up or down.
lines(t, -3*t + 1, col="red", lty="dashed")
# Changes the pitch of the line
plot(t, 0.25 * t - 1, type = "l")

#QRQ 2
t = seq(-1, 4, 0.1)
plot(t, -4.9*t^2 + 15*t + 11, type="l")
lines(t, -4.9*t^2 + 15*t + 2, col="green", lty="dashed", type="l")
# c.  About t = 1.5
# d. Changes the concavity:  Positive coefficient for makes
# the graph concave up; negative, down.  Rotates the graph around
# the x-axis

#QRQ 3
t = seq(-3, 3, 0.1)
plot(t, t^2, type="l")
lines(t, t^2 + 3, lty="dashed", type="l")
lines(t, t^2 - 3, lty="dotted", type="l")
# b. Moves the graph up and changes the y-intercept
# c. Moves the graph down and changes the y-intercept
plot(t, t^2, type="l")
lines(t, (t + 3)^2, lty="dashed", type="l")
lines(t, (t - 3)^2, lty="dotted", type="l")
# e. Moves the graph to the left
# f. Moves the graph to the right
plot(t, t^2, ylim=c(-5,5), type="l")
lines(t, -t^2, lty="dashed", type="l")
# h. Rotates the graph around the x-axis
plot(t, t^2, type="l")
lines(t, 5*t^2, lty="dashed", type="l")
lines(t, 0.2*t^2, lty="dotted", type="l")
# j. Makes graph thinner
# k. Makes graph more spread out

#QRQ 4
#a.
t = seq(-2, 5, 0.1)
plot(t, t^3 - 4*t^2 - t + 4, type="l")
#b. Infinity
#c. Minus infinity
#d. lines(t, -t^3 + 4*t^2 + t + 4, lwd = 3, lty = "dashed")
#e. Minus infinity
#f. Infinity

#QRQ 5
#a.
t = seq(0, 3, 0.01)
plot(t, sqrt(t), type="l")
#b.
t = seq(5, 8, 0.01)
plot(t, sqrt(t - 5), type="l")
#c.
t = seq(0, 3, 0.01)
plot(t, sqrt(t) + 3, type="l")
#d.
plot(t, -sqrt(t), type="l")
#e.
plot(t, 2*sqrt(t), type="l")

#QRQ 6
#a.
u = function (t) 500*exp(0.12*t)
#b.
t = seq(0, 10, 0.1)
plot(t, u(t), type="l")
#c.  The function with continuous rate 14% rises the fastest.
lines(t, 500*exp(0.13*t), lwd = 3, lty = "dashed")
lines(t, 500*exp(0.14*t), lwd = 3, lty = "dotted")
#d.
r = 0.12/log(4)
u = function (t) 500*4^(r*t)

#QRQ 7
#a.
v = function (t) 5*exp(-0.82 * t)
#b.
plot(t, v(t), type = "l")
#c.
lines(t, v(t) + 1, lty = "dashed")
#d. Adds 7 to each y-coordinate; moves graph up by 7
#e. 0
#f. 7
#g.
plot(t, v(t), type = "l", ylim = c(-5, 5))
lines(t, -v(t), type = "l", lty = "dashed")
#h. Rotates graph around t-axis
#i.
plot(t, v(t), type = "l", ylim = c(0, 8))
lines(t, 7 - v(t), type = "l", lty = "dashed")
#j. 7
#k. 2

#QRQ 8
#a.
f = function (t) 12*t*exp(-2*t)
t = seq(0, 5, 0.01) # smaller step size to smooth out curve
plot(t, f(t), type = "l")
#b. t
#c. exp(-2*t)

#QRQ 9
#a.
log2(8)
#b. e^y = 7
#c.
log(exp(5.3))
#d.
10^log10(5.3)

#QRQ10
#a.
p = function (M, P0, r) M*P0/((M - P0)*exp(-r*t) + P0)
t = seq(0, 16, 0.1)
plot(t, p(1000, 20, 0.5, t), type = "l")
#b.
lines(t, p(1000, 100, 0.5, t), type = "l", lty = "dashed")
lines(t, p(1000, 200, 0.5, t), type = "l", lty = "dotted")
#c. larger P0 values the initial heights (at time 0) higher
#d.
plot(t, p(1000, 20, 0.2, t), type = "l")
lines(t, p(1000, 20, 0.5, t), type = "l", lty = "dashed")
lines(t, p(1000, 20, 0.8, t), type = "l", lty = "dotted")
#e. larger r values make graph steeper
#f.
plot(t, p(1000, 20, 0.5, t), type = "l", ylim = c(0, 2000))
lines(t, p(1300, 20, 0.5, t), type = "l", lty = "dashed")
lines(t, p(2000, 20, 0.5, t), type = "l", lty = "dotted")
#g. graph approaches M value as t goes to infinity
# Larger M values make graphs go to higher values

#QRQ 11
#a.
0.8/0.6
#b.
sin(pi/3)
#c. -infinity to infinity
#d. -1 to 1, inclusive
#e. 2*pi
#f.
#g. positive
#h. positive
#i. negative
#j. negative

#QRQ 12
#a.
cos(0)
#b.
cos(pi/2)
#c.
cos(pi)
#d.
cos(2*pi/2)
#e.
cos(pi/3)
#f. 1
#g. -1
#h. set of all real numbers
#i. 2*pi
#j. positive
#k. negative
#l. negative
#m. positive

#QRQ 13.
#a.
t = seq(0, 2*pi, 0.01) # smaller step size to have smoother curve
plot(t, sin(t), type = "l")
lines(t, sin(7*t), type = "l", lty = "dashed")
#b.
t = seq(0, 6*pi, 0.01)
plot(t, sin(t), type = "l", ylim = c(-5,5))
lines(t, 5*sin(t/3), type = "l", lty = "dashed")
#c.
t = seq(0, 2*pi, 0.01)
plot(t, sin(t), type = "l", ylim = c(-2, 4))
lines(t, 3*sin(t) + 1, type = "l", lty = "dashed")
#d.
plot(t, sin(t), type = "l", ylim = c(-4, 4))
lines(t, 4*sin(2*t + pi/6), type = "l", lty = "dashed")
#e.
plot(t, cos(t), type = "l", ylim = c(-4, 4))
lines(t, 3*cos(2*t + pi/5), type = "l", lty = "dashed")
#f.
plot(t, sin(5*t), type = "l")
lines(t, exp(-t)*sin(5*t), type = "l", lty = "dashed")

#QRQ 14
#a.
tan(pi/3)
#b.
tan(0)
#c.
tan(pi)
#d.
tan(pi/2)
#e. infinity
#f. -infinity
#g. undefined
tan(-pi/2)
#h. -infinity
#i. infinity
#j. set of all real numbers
#k. -3*pi/2, -pi/2, pi/2, 3*pi/2
#l. For example, 5*pi/4
#m. For example, 7*pi/4
#n. pi