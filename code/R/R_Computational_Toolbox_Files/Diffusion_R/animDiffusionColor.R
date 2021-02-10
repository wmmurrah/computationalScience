# animate grids in color with hotter being more red, colder more blue
animDiffusionColor  <- function(graphList){	
	utils::globalVariables(c("HOT"))
	lengthGraphList = dim(graphList)[3]
	
	# set up color map
	map <- 1:(HOT + 1)
	for (i in 0:HOT) {
		amt <- i/HOT
		map[i + 1] <- rgb(amt, 0, 1-amt)  # red-green-blue amounts
	 }
	 
	m = dim(graphList)[1]
	n = dim(graphList)[2]
	
	# determine window size
	# 1.6 is approximately the golden ratio; used so cell pictured as square
	fraction = n/m
	dev.new(width = 2 * fraction, height = 2 * 1.6)
	
	for( k in 1:lengthGraphList) {
		dev.hold()
	    g = t(graphList[,,k])  # transpose because of following comment

#"image interprets the z matrix as a table of f(x[i], y[j]) values, so that the x axis corresponds to row number and the y axis to column number, with column 1 at the bottom, i.e. a 90 degree counter-clockwise rotation of the conventional printed layout of a matrix."

		# first row's image is on bottom, unlike figures in text
	    image(HOT - g + 1, col = map, axes = FALSE)
	    box()
	    Sys.sleep(0.1)
	    dev.flush()
	}	
}