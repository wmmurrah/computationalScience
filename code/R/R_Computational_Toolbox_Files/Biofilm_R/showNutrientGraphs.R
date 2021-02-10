showNutrientGraphs<- function (nutGrids){
# SHOWNUT - Function to return a movie visualization of grids in 3-dimensional
# array nutGrids
#   Nutrient values are represented in a gray scale: the lighter the value
#   the smaller the nutrient value 

 	utils::globalVariables(c(" MAXNUTRIENT"))
	t = length(nutGrids[1,1,])
	
	for( k in 1:t) {
		dev.hold()
	g = t(nutGrids[,,k])  # transpose because of following comment "image interprets the z 
	# matrix as a table of f(x[i], y[j]) values, 
	# so that the x axis corresponds to row number and the y axis to column number, with 
	# column 1 at the bottom, i.e. a 90 degree counter-clockwise rotation of the conventional 
	# printed layout of a matrix."
	
	# first row's image is on bottom, unlike figures in text
	    image(1 - g/MAXNUTRIENT, col = grey(seq(0,1, length = 10)), axes = FALSE)
	    box()
	    Sys.sleep(0.1)
	    dev.flush()
	}	
}

