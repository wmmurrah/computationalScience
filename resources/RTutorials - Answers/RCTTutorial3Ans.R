# RCTTutorial3.R answers

#QRQ 1
qrq = matrix(rep(0, 8), nrow = 2)
qrq[1, ] = seq(1, 7, 2)
3 * qrq
sqrt(qrq)
qrq = 2 + qrq

#QRQ 2
qrq2 = matrix(rep(0, 8), nrow = 2)
qrq2[,1] = c(1, 1)
qrq2[1, 3] = 5
qrq2
qrq + qrq2
qrq * qrq2
sqr = function(x) x * x
# to return a matrix of squares
sqr(qrq)
# to return a vector of squares
sqr(c(qrq[1,], qrq[2,]))
sum(sqr(qrq))

#QRQ 3
xlst = 1:9
glst = 3 * sqrt(xlst)
pairslst = cbind(xlst, glst)
pairslst