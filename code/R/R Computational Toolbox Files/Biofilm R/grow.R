grow <-function( bacteriaGrid, nutritionGrid, p ){
#GROW gives a new bacteria grid accounting for the growth of the Bacteria
#        grow( bacteriaGrid, nutritionGrid, p ) returns a new bacteria grid
#        that accounts for growth and death of bacteria in relation to
#        nutrition and a partial probability p

	utils::globalVariables(c("BACTERIUM","DEAD"))
	bacGrid = bacteriaGrid
	m = nrow(nutritionGrid)
	n = ncol(nutritionGrid)
	extBacGrid = extendBacteriaGrid(bacteriaGrid)
	extNutGrid = extendNutrientGrid(nutritionGrid)
	
	for (i in 2:(m+1)){ 
	    for (j in 2:(n+1)){
	        if (extBacGrid [i, j] == BACTERIUM){
				if (extNutGrid[i, j] <= 0){
					bacGrid[i-1, j-1]= DEAD
				}else{
				if(runif(1) < (p * extNutGrid[i, j])){ 
					newiANDnewj= pickNeighbor(i, j, m, extBacGrid[i-1, j],extBacGrid[i, j+1], 
						extBacGrid[i+1,j], extBacGrid[i,j-1])
					newi= newiANDnewj[1]
					newj= newiANDnewj[2]
	                bacGrid[newi,newj] = BACTERIUM
					}
				}
			}
	    }
	}
	return(bacGrid)
}
