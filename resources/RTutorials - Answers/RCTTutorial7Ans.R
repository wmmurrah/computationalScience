# RCTTutorial7Ans.R

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
mA %*% mB

## QRQ 2 a
mC = diag(3)
for (j in 1:3){
	for (i in 1:3){
		mC[i, j] = 2 * i - j
	}
}

## QRQ 2 b
prod = diag(3)for (i in 1:7) {	prod = prod %*% mC}
prod

## QRQ 2 cmC %*% mC %*% mC %*% mC %*% mC %*% mC %*% mC

## QRQ 3 a
mD = matrix(c(4, 3, 6, 1), nrow = 2)

## QRQ 3 b
eig = eigen(mD)

## QRQ 3 c
lLst = eig$values
vLst = eig$vectors

## QRQ 3 d
mD %*% vLst[, 1]
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

