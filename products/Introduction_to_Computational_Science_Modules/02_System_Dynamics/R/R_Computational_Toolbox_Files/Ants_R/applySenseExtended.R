applySenseExtended <- function(antGrid, pherGrid){

# function to apply sense so that the ant can move accordingly

#utils::globalVariables(c("MAXPHER", "EVAPORATE","DEPOSIT","THRESHOLD","EMPTY","STAY"))
utils::globalVariables(c("EMPTY"))
n = length(antGrid[,2])- 2
newAntGrid = antGrid

 for (i in 2:(n+1)){

    	for(j in 2:(n+1)){

        	if (antGrid[i,j] != EMPTY){

            		site = antGrid[i,j]
            		Nant = antGrid[i-1,j]
            		Eant = antGrid[i,j+1]
            		Sant = antGrid[i+1,j]
            		Want = antGrid[i,j-1]
            		Npher = pherGrid[i-1,j]
            		Epher = pherGrid[i,j+1]
            		Spher = pherGrid[i+1,j]
            		Wpher = pherGrid[i, j-1]

           		newAntGrid[i, j] = sense(site, Nant, Eant, Sant, Want, Npher, Epher, Spher, Wpher)

        	}
 
        }

   }
return(newAntGrid)

}
