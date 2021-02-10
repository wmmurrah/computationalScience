applyDiffusionExtended<-function( matExt, diffusionRate ){
#   APPLYDIFFUSION applies diffusion function to each grid cell
#   newNutrientGrid ] = applyDiffusion( nutrientGrid, diffusionRate )
#   takes nutrientGrid (matrix) and diffusionRate and returns the grid 
#   with the function diffusion applied to each element of the original grid 

	m = nrow(matExt)- 2
	n = ncol(matExt) - 2
	newNutrientsGrid = matrix(rep(0,m*n),nrow=m)
	for( i in 2:(m+1)){
	    for( j in 2:(n+1)){
	        site = matExt[i, j]
	        N = matExt[i-1, j]
	        NE = matExt[i-1, j+1]
	        E = matExt[i, j+1]
	        SE = matExt[i+1, j+1]
	        S = matExt[i+1, j]
	        SW = matExt[i+1, j-1]
	        W = matExt[i, j-1]
	        NW = matExt[i-1, j-1]
	        newNutrientsGrid[i-1, j-1] = 
	        		diffusion(diffusionRate, site, N, NE, E, SE, S, SW, W, NW)
	    }
	}
	return(newNutrientsGrid)
}

