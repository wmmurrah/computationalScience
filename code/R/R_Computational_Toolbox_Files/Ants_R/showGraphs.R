showGraphs<- function (antGrids, pherGrids){
utils::globalVariables(c(" EMPTY"));

n = length(antGrids[,1,1]) - 2
maxp = max(max(max(pherGrids[,,])))
map = append(rgb(1,0,0),gray(seq(0,1,length=maxp)))

m = length(antGrids[1,1,])
gr = matrix(rep(0,n*n), nrow=n)
for(k in 1:m){
    dev.hold()	
    a = antGrids[, , k]
    p = pherGrids[, , k]
    for (i in 2:(n+1)){
        for (j in 2:(n+1)) {
            if (a[i, j] == EMPTY) {
                gr[i-1, j-1] = 1 - (p[i, j]+1)/(maxp+1) # most chemical -> black
                }
            else {   
                gr[i-1, j-1] = 0  # make ant lowest value, -> red
            	}   
        	}
   	 }
    
	image(gr, col=map, axes=FALSE) 
	box()
	Sys.sleep(0.1)
	dev.flush()
	}
}
