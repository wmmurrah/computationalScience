applyExtended = function(latExt, probLightning, probImmune) {
# APPLYEXTENDED - Function to apply 
# spread(site, N, E, S, W, probLightning, probImmune) to every interior
# site of square array latExt and to return the resulting array
	n = nrow(latExt) - 2
	newmat = matrix(c(rep(0,n*n)), nrow = n)
	for (j in 2:(n + 1)) {
	    for (i in 2:(n + 1)) {
	        site = latExt[i, j]
	        N = latExt[i - 1, j]
	        E = latExt[i, j + 1]
	        S = latExt[i + 1, j]
	        W = latExt[i, j - 1]
	        newmat[i - 1, j - 1] = spread(site, N, E, S, W, probLightning, probImmune)
	    }
	}
	return(newmat)
}
