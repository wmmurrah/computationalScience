# Alternative R Tutorial 7 Answers
# RCTTutorial7AltAns.R

## 
### From Tutorial 1
### 

## QRQ 9 a
ages = c(19,21,21,20)
 
## QRQ 9 b
names = c("Ruth", "Callixte", "Talisha")
 
## QRQ 11 a
quick = function(x) 3 * sin(x-1) + 2

## QRQ 11 b
quick(5)

## QRQ 12
# ?log10

## QRQ 13
# sd

# QRQ 15	
d = 1
for (i in 1:10) {
    d = d * 2
}
cat(d,"\n")


# QRQ 16	
for (i in 1:7) {
   dist = 2.25 * i
   t =  (24.5 - sqrt(600.25 - 19.6 * dist))/9.8;
   cat("For distance ",dist,", time = ", round(t,2), " seconds.\n",sep="");
}



# QRQ 17 a.	
qrq17 = function(x) log(3*x + 2)

# QRQ 17 b.	
for (k in 1:8) {
    cat("k=",k,", qrq17(k)=",qrq17(k),"\n",sep="")
}

# QRQ 18	
x11()
plot(exp(sin(seq(-3,3,.1))))

# QRQ 19	
x11()
plot(exp(sin(seq(-3,3,.1))),xlab="x",ylab="e^sin(x)")

## 
### From Tutorial 2
### 
# QRQ 1
v1a = c(47, 35, 22, 10)
v1b = 1:12
v1c = seq(4, 84, 4)
v1d = c(rep(3, 11), rep(4, 11), rep(5, 12))
v1e = c(seq(7, 1, -1), 19, seq(2, 30, 2))

# QRQ 2
t = c(57, 61, 63, 64, 88, 89, 88, 86, 70, 81, 76, 76)
temperatures = matrix(t,nrow=3)
temperatures[3, 3]
temperatures[2, 1]
temperatures[3,]
temperatures[,2]
temperatures[c(1, 3), 2:4]

# QRQ 3
airPressure = array(dim=c(5,5,3))
for (i in 1:5) { 
	for (j in 1:5) {
  		airPressure[i,j,1] = 1
  		airPressure[i,j,2] = .99
  		airPressure[i,j,3] = .98
	}
}
airPressure[3, 3, 3]
airPressure[4, 2, 1]
airPressure[3, , ]
airPressure[, , 1]
airPressure[4, 2:5, ]

## 
### From Tutorial 3
### 

# QRQ 1
qrq = matrix(rep(0, 8), nrow = 2)
qrq[1, ] = seq(1, 7, 2)
3 * qrq
sqrt(qrq)
qrq = 2 + qrq

# QRQ 3
xlst = 1:9
glst = 3 * sqrt(xlst)
pairslst = cbind(xlst, glst)
pairslst

## 
### From Tutorial 4
### 

#QRQ 1 a
#a.
runif(1,min=10,max=100)
#b
runif(5,min=-3,max=3)
#c
matrix(runif(8,min=8 ,max=12 ),nrow=2)

## 
### From Tutorial 5
###

## QRQ 4
# a See rectCircumference.R
# b 
source("rectCircumference.R")
rectCircumference(3, 4.2)

## QRQ 6
# a See squareStats.R
# b
source("squareStats.R")
# c
stats = squareStats(3)
# d
area = stats[1]
circumference = stats[2]

## QRQ 8
x = 0
i = 1
while ((-5 <= x) && (x <= 5)) {
	plot(x, 0, xlim = c(-5, 5), ylim = c(-1, 1))
	Sys.sleep(0.25)
    i = i + 1
	x = x + randIntRange(-1, 2)
}

## 
### From Tutorial 6
### 

## 
### From Tutorial 7
### 

## QRQ 1 a
mA = matrix(rep(1, 8), nrow = 4)
for (j in 1:2){
	for (i in 1:4){
		mA[i, j] = i + j
	}
}

## QRQ 1 b
mO = matrix(rep(1, 8), nrow = 4)

## QRQ 1 c
mA + mO

## QRQ 1 d
u = c(2, 7)

## QRQ 1 e
v = c(5, 3)

## QRQ 1 f
sum(u * v)

## QRQ 1 g
mB = matrix(rep(1, 6), nrow = 2)
for (j in 1:3){
	for (i in 1:2){
		mB[i, j] = i - j
	}
}

## QRQ 1 h
mA #*# mB

## QRQ 2 a
mC = diag(3)
for (j in 1:3){
	for (i in 1:3){
		mC[i, j] = 2 * i - j
	}
}

## QRQ 2 b
prod = diag(3)for (i in 1:7) {	prod = prod #*# mC}
prod

## QRQ 2 cmC #*# mC #*# mC #*# mC #*# mC #*# mC #*# mC

## QRQ 3 a
mD = matrix(c(4, 3, 6, 1), nrow = 2)

## QRQ 3 b
eig = eigen(mD)

## QRQ 3 c
lLst = eig$values
vLst = eig$vectors

## QRQ 3 d
mD #*# vLst[, 1]
lLst[1] * vLst[, 1]

## QRQ 4 a
lst1 = floor(runif(5, min = 0, max = 3))

## QRQ 4 b
unique(lst1)
lst1

## QRQ 4 c
lst2 = floor(runif(5, min = 10, max = 13))
lst3 = union(lst1, lst2)
lst2
lst3

## QRQ 4 d
dup1 = cbind(lst1, lst2)
dup1[order(-dup1[, 2]), ]

