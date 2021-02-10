consumption<-function( bacteriaGrid, nutritionGrid ){
#       CONSUMPTION gives a nutrition grid after consumption by bacteria
#       consumption( bacteriaGrid, nutritionGrid )returns a new
#       nutritionGrid that accounts for the loss of nutrition to Bacteria
#       consumption in the previous step.

	utils::globalVariables(c(" BACTERIUM", "CONSUMED"))
	m = nrow(nutritionGrid)
	
	n = ncol(nutritionGrid)
	
	nutGrid = nutritionGrid
	
	for (i in 1:m){
	    for( j in  1:n){
	        if( bacteriaGrid[i,j] == BACTERIUM){
	            nutGrid[i,j]= max(0.0, (nutGrid[i,j] - CONSUMED) )
	        }
	    }
	}
	 return(nutGrid)               
}

