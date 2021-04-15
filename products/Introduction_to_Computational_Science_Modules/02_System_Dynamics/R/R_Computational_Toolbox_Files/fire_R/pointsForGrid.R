pointsForGrid = function(grid,val) {
# Helper function for showGraphs
# Pre: grid is a square grid
#       val is a possible element value
# Pre: The function has returnd a list of xcoords and ycoords,
#      coordinates of cells that have value val.
#      To match matrix values, the rows are reversed.
    xcoords = vector()
    ycoords = vector()
    for (row in 1:nrow(grid)) {
        for (col in 1:ncol(grid)) {
            if (grid[row,col] == val) {
                xcoords[length(xcoords)+1] = col
                ycoords[length(ycoords)+1] = nrow(grid) - row
            }
        }
    }
    return(list(xcoords,ycoords))
}
