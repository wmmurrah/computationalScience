# Callixte Nahimana
# September,28 2013

#Function to plot graph the position of a random walk animal
# M is the matrix of x and y coordinates of animal walk position
			
animateWalk = function(M){
	xStepLst = M[,1]
	yStepLst = M[,2]
	minX = min(xStepLst)
	minY = min(yStepLst)
	maxX=max(xStepLst)   
	maxY=max(yStepLst)
	minP = min(min(M[,1]),min(M[,2]))
	maxP = max(max(M[,1]),max(M[,2]))
	# setting up coord. system
	plot(minP:maxP,minP:maxP,ylab="yLst",xlab="xLst",type = "n",main="Graph of Random walk of n points")  
	lng =length(xStepLst)
	
	#Graphing the animal walk position
	
	for (i in 1:lng){
		#add each single point to the plane. cex change the point look
		points(xStepLst[i],yStepLst[i],col="red",cex=1.5) 
	}
}
