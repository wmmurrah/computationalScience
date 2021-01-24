initBacteriaGrid<- function( m, n, probInitBacteria ){
# INITBACTERIAGRID gives a bateria grid that is EMPTY except the first column
#       initBacteriaGrid( m,n,probInitBacteria ) returns a bateria grid 
#       that is EMPTY except the first column, where the probability of a 
#       bacterium in a cell is probInitBacteria

	utils::globalVariables(c("EMPTY","BACTERIUM"))
	
	bacteriaGrid = matrix(rep(0,m*n)+EMPTY,nrow=m)
	
	for(i in 1:m){
	    if (runif(1) < probInitBacteria){
	        bacteriaGrid[i, 1] = BACTERIUM;
	    }
	}
	return(bacteriaGrid)
}

