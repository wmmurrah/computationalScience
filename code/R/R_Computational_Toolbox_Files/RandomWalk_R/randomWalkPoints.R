randomWalkPoints <- function (n){
# RANDOMWALK  Function to generate lists of x and y
# coordinates of n steps for a random walk of n steps.
# Return the matrix of x and y coordinates
	x0=0
	y0=0
	x=x0
	y=y0
	xLst<-matrix(rep(0,n+1),nrow =1)
	yLst<-matrix(rep(0,n+1),nrow=1)
	xLst[1,1]<-x0
	yLst[1,1]<-y0
	for(i in 1:n){
		if(runif(1)<0.5){x=x+1}else{x=x-1}
		if(runif(1)<0.5){y=y+1}else{y=y-1}
		xLst[1,i+1]<-x
		yLst[1,i+1]<-y
		}
	M = matrix(c(xLst,yLst),ncol=2)
	dist = sqrt((x-x0)*(x-x0) + (y-y0)*(y-y0))
	return(M)
}
