fire = function(n, probTree, probBurning, probLightning, probImmune, t) {
# FIRE simulation
	utils::globalVariables(c("EMPTY", "TREE", "BURNING"))
	EMPTY = 0
	TREE = 1
	BURNING = 2

    forest  = initForest( n, probTree, probBurning )
    grids = array(dim=c(n,n,t+1))
    
    grids[,,1] = forest

    for (i in 2:(t+1)) {
        forestExtended = periodicLat(forest)
        forest = applyExtended(forestExtended, probLightning, probImmune)
        grids[,,i] = forest
    }

    return(grids)
}
