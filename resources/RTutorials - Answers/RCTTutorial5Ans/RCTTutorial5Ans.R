# MATLAB Tutorial 5 Answers
# File:  MATLABTutorial5Ans.m

## QRQ 1 a
lst = runif(100)
max(lst)
min(lst)

## QRQ 1 b
z = rep(0, floor(20*runif(1) + 1))
length(z)

## QRQ 2
xLst = runif(10)
yLst = runif (10)
for (n in 1:10) {
	plot(xLst[1:n], yLst[1:n], xlim = c(0, 1), ylim =c (0, 1))
	Sys.sleep(0.25)
	}

##
## QRQ 3
f = function(t, i)	{(1000*20)/((1000 - 20)*exp(-(1+0.2*i)*t) + 20)}
t = seq(0,3,0.1)
for (i in 1:10) {
   plot(t, f(t, i) , type='l', xlim = c(0, 3), ylim = c(0, 1000))
	Sys.sleep(0.1)
	}

## QRQ 4
# a See rectCircumference.R
# b 
source("rectCircumference.R")
rectCircumference(3, 4.2)
##
## QRQ 5
# a See randIntRange.R
# b
source("randIntRange.R")
# c
for (i in 1:10) {
    cat(randIntRange(5, 9), "\n")
}
##
## QRQ 6
# a See squareStats.R
# b
source("squareStats.R")
# c
stats = squareStats(3)
# d
area = stats[1]
circumference = stats[2]

##
## QRQ 7
# Change values for x and y to test various situations
x = 5
y = 5
if ((x + 2 > 3) || (y < x)) {
    y = y + 1
} else {
	x = x - 1
     }
    
##
## QRQ 8
x = 0
i = 1
while ((-5 <= x) && (x <= 5)) {
	plot(x, 0, xlim = c(-5, 5), ylim =c (-1, 1))
	Sys.sleep(0.25)
    i = i + 1
	x = x + randIntRange(-1, 2)
}