ants <- function (n, probAnt, diffusionRate, t){
#% ANTS - Function to return a list of ant and pheromone grids in a
#% simulation of ant movement, where ant cell values are as in Table 10.4.1
#% and pheromone cell values represent the levels of pheromone

antGrid = initAntGrid(n, probAnt);
pherGrid = initPherGrid(n);
antGrids = array(rep(0,(n+2)*(n+2)),c(n+2,n+2,t+1)) # antGrids=zeros(n+2, n+2, 1, t+1);
antGrids[,,1] = antGrid
pherGrids = array(rep(0,(n+2)*(n+2)),c(n+2,n+2,t+1))
pherGrids[,,1] = pherGrid;


for (i in 1:t){

	antGrid = applySenseExtended(antGrid,pherGrid);
    	both =  walk(antGrid, pherGrid);
   	antGrid =both[,,1]
	pherGrid = both[,,2]
	pherGrid = applyDiffusionExtended(pherGrid, diffusionRate);
	antGrids[, ,i+1] = antGrid;
	pherGrids[, , i+1] = pherGrid;
}
	
# return antGrids and pherGrids as a list,first element 
# being antGrids and second element being pherGrid
return(list(antGrids,pherGrids))	
}
