showBacteriaGraphs<-function (bacGrids){
# SHOWBAC - Function to return a movie visualization of grids in 3-dimensional
# array bacGrids

	t = length(bacGrids[1,1,])
    
# EMPTY, yellow; BACTERIA, green; DEAD, gray
    
	for( k in 1:t){
	    dev.hold()
		g = t(bacGrids[,,k])
		
		# Have 2 colors if no dead bacteria, 3 colors if dead bacteria
		if (max(g) == 1) {
			map =c(rgb(1,1,0),rgb(0,1,0))
			}
		else {
			map = c(rgb(1,1,0),rgb(0,1,0),rgb(0.5,0.5,0.5))
		}
	
		image(g, col = map, axes = FALSE);
		box()
		Sys.sleep(0.1)
		dev.flush()
	}
}
