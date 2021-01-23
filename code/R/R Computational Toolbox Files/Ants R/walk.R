walk <- function (antGrid,pherGrid) {
#% WALK - Function to return a new ant and pheromone grids after each ant has moved or decided to remain in its current location
utils::globalVariables(c("EMPTY","NORTH","EAST","SOUTH","WEST","STAY","EVAPORATE","THRESHOLD","DEPOSIT"))
EMPTY = 0; NORTH = 1; EAST = 2; SOUTH = 3; WEST = 4; STAY = 5; BORDER = 6;
n = ncol(antGrid) - 2
newAntGrid = antGrid
newPherGrid = pherGrid

#Create a multi array both to return both NewAntGrid and NewPherGrid

both = array(0,c(ncol(newAntGrid),ncol(newPherGrid),2))

for(i in 2:(n+1)){

    for (j in 2:(n+1)){
        if(antGrid[i, j] == EMPTY){
            newPherGrid[i, j] = max(c(newPherGrid[i, j] - EVAPORATE, 0))
        }

    #    % else if can move in desired direction (no ant there now and no ant  already planning to go there at the next time step), increment 
    #    % pheromone in site, make site empty, and change value in desired site to have ant and to point in the direction from where it came

        if(antGrid[i,j] == NORTH) { 
            if(newAntGrid[i-1,j] == EMPTY) {    
                if(newPherGrid[i,j] > THRESHOLD){ 
                    newPherGrid[i,j] = newPherGrid[i,j] + DEPOSIT
                }
                newAntGrid[i,j] = EMPTY
                newAntGrid[i-1,j] = SOUTH
           }else{
                newAntGrid[i,j] = STAY # % can't move
            }
        }

        if(antGrid[i,j] == EAST){ 
            if(newAntGrid[i,j+1] == EMPTY){ # can move 
                if(newPherGrid[i,j] > THRESHOLD){
                    newPherGrid[i,j] = newPherGrid[i,j] + DEPOSIT;
                }
                newAntGrid[i,j] = EMPTY;
                newAntGrid[i,j+1] = WEST;
            }else{
                newAntGrid[i,j] = STAY;# % can't move 
            }
       }

        if(antGrid[i,j] == SOUTH){ #% can move 
            if(newAntGrid[i+1,j] == EMPTY){
                if(newPherGrid[i,j] > THRESHOLD){
                    newPherGrid[i,j] = newPherGrid[i,j] + DEPOSIT;
                }
                newAntGrid[i,j] = EMPTY;
                newAntGrid[i+1,j] = NORTH;
           }else{
                newAntGrid[i,j] = STAY;# % can't move
            }
        }

        if(antGrid[i,j] == WEST) {#% can move 
            if(newAntGrid[i,j-1] == EMPTY){
                if(newPherGrid[i,j] > THRESHOLD){
                    newPherGrid[i,j] = newPherGrid[i,j] + DEPOSIT;
                }
                newAntGrid[i,j] = EMPTY;
                newAntGrid[i,j-1] = EAST;
           } else{
                newAntGrid[i,j] = STAY;# % can't move 
            }
        }

#	k = newAntGrid
#	t = newPherGrid

        both[,,1]= newAntGrid
        both[,,2]= newPherGrid

        #return both newAntGrid and newPherGrid as a multidimension array
    }
}

return(both)
}
