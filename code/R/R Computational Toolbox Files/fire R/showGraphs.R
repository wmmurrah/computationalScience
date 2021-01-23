showGraphs = function(graphList) {
# SHOWGRAPHS - Function to perform animation of grids in graphList
	m = dim(graphList)[3]
	for (k in 1:m) {
		g = graphList[,,k]
        trees = pointsForGrid(g,TREE)
        burnings = pointsForGrid(g,BURNING)
        plot(trees[[1]],trees[[2]],pch=19,col="green",
            xlim=c(0,n+1),ylim=c(0,n+1))
        points(burnings[[1]],burnings[[2]],col="red",pch=23,bg="orange")
        Sys.sleep(0.2)
       }
}
