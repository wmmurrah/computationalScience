spread = function(site, N, E, S, W, probLightning, probImmune) {
# SPREAD - Function to return the value of a site
# at the next time step
# An empty cell remains empty.
# A burning cell becomes empty.
# If a neighbor to the north, east, south, or west of 
# a tree is burning, then the tree does not burn with a
# probability of probImmune.
# If a tree has no burning neighbors, it is hit by lightning
# and burns with a probability of probLightning * (1 - probImmune).

	utils::globalVariables(c("EMPTY", "TREE", "BURNING"))
    if (site == EMPTY){
    	newSite = EMPTY
    	}
	else if (site == BURNING){
        newSite = EMPTY
        }
    else if (site == TREE) {
        if (N == BURNING || E == BURNING || S == BURNING || W == BURNING) {
            if (runif(1) < probImmune)
            	newSite = TREE
            else
            	newSite = BURNING
            }
    	else if (runif(1) < probLightning * (1 - probImmune))
        	newSite = BURNING
    	else
        	newSite = TREE
    	}
    return(newSite)
}
