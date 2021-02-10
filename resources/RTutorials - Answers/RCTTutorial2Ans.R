# RCTTutorial2.R

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

# QRQ 4
yLst = c(6, 2, 9, 9, 12)
xCoords = c(-3,2,-1,4,0)
plot(xCoords, yLst)

