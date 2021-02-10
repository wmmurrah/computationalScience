initPherGrid <- function(n){
	
# function to initialize the pherGrid 

utils::globalVariables(c("MAXPHER"))

Grid = matrix(rep(0,(n+2)*(n+2)), n+2)
mid = ceiling((n+2)/2)
for(i in 1:n){

	Grid[mid,i+1]<-i/n*MAXPHER
}

return(Grid)
}
