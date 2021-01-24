extendBacteriaGrid<- function(mat ){
#   EXTENDBACTERIAGRID Adds a boundary around the matrix
#   extendBacteriaGrid( mat ) Takes mat, an m-by-n matrix parameter and
#   return an (m+2) by (n+2) matrix with periodic boundary conditons in the
#   north and south directs, with first and last columns of fixed value
#   BORDER.

	utils::globalVariables(c("BORDER"))
	extendedGrid = mat
	m = nrow(mat)
	
	matNS = rbind(mat[nrow(mat),],mat,mat[1,])
	border = BORDER* matrix(rep(1,m+2), nrow=m+2)
	
	extendedGrid = cbind(border, matNS, border)
	return(extendedGrid)
}

