extendNutrientGrid<- function( mat ){
#   EXTENDNUTRIENTGRID Adds a boundary around the matrix
#   extendNutrientGrid( mat ) Takes mat, an m-by-n matrix parameter and
#   return an (m+2) by (n+2) matrix with periodic boundary conditons in the
#   north and south directs, a first column of zeros, and a last colum with
#   constant value MAXNUTRIENT

	utils::globalVariables(c(" MAXNUTRIENT"))
	extendRows = rbind(mat[nrow(mat),],mat,mat[1,])
	m = nrow(mat) 
	substrate = matrix(rep(0,m+2),ncol=1) 
	constNutrient = MAXNUTRIENT * matrix(rep(1,m + 2),ncol= 1)
	extendedGrid = cbind(substrate, extendRows, constNutrient)
	
	return(extendedGrid)
}
