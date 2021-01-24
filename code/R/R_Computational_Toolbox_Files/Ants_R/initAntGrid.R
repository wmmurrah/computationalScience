#Callixte Nahimana
# October 27 2013
initAntGrid<-function(n,probAnt){

#% INITANTGRID --initialization of n+2-by-n+2 array for ant simulation
#% probAnt is the probability that a site has an ant

#utils::globalVariables(c("NORTH","SOUTH","WEST","BORDER","STAY","EAST", "EVAPORATE","DEPOSIT","THRESHOLD","EMPTY","STAY"))
utils::globalVariables(c("NORTH","SOUTH","WEST","BORDER","STAY","EAST","EMPTY"))

 EMPTY = 0
 NORTH = 1
 EAST = 2
 SOUTH = 3
 WEST = 4
 STAY = 5
 BORDER = 6
 grid = BORDER*matrix(rep(1,(n+2)*(n+2)),ncol=n+2)

 for(i in 2:(n+1)){
		for(j in 2:(n+1)){
 			if(runif(1) <probAnt){
				grid[i,j]=floor(runif(1,1,5)) 
			}
		  	else{
				grid[i, j] = EMPTY
			 }

		}

}

return(grid)
}
