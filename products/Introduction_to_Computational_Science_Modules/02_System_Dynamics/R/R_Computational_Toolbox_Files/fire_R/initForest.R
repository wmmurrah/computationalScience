initForest = function( n, probTree, probBurning ){
#INITFOREST returns an n-by-n grid of values?EMPTY (no tree), 
# TREE (non-burning tree), or BURNING (burning tree)
# Pre:	n is the size (number of rows or columns) of the square grid and is positive.
# 	probTree is the probability that a site is initially occupied by tree.  
# 	probBurning is the probability that a tree is burning initially. 
# Post:	 A grid as described above was returned.
	utils::globalVariables(c("EMPTY", "TREE", "BURNING"))
	# 1 where tree or burning tree
	treesOrBurns = matrix(runif(n^2) < probTree,nrow=n)
	# 1 where burning tree
	burns = treesOrBurns * matrix(runif(n^2) < probBurning,nrow=n)
	# 1 where non-burning tree
	trees = treesOrBurns - burns
	# 1 where empty
	empties = 1 - treesOrBurns
	# EMPTY, TREE, or BURNING
	forest =  empties * EMPTY + trees * TREE + burns * BURNING
	return (forest)
}