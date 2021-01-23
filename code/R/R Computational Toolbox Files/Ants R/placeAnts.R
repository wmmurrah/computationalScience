placeAnts<- function (antGrid, pherGrid){

# This function takes an antGrid, pherGrid and return a new grid with
# ants and pheromone on the same grid

utils::globalVariables(c(" EMPTY"));
newPherGrid = pherGrid
n = nrow(antGrid)

# Go through the grid and wherever there is an ant, put NA which will be used for 
# coloring purposes(Red which will represent the cell with an ant

for (i in 2:(n-1)){
	for(j in 2:(n-1)){
		if(antGrid[i,j] !=0){
			newPherGrid[i,j] = NA
			}					
		}
	}
	return(newPherGrid)
}






