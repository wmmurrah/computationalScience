sense<-function(site, na, ea, sa, wa, np, ep, sp, wp){
utils::globalVariables(c("EMPTY","STAY"))
EMPTY = 0
STAY = 5
if (site == EMPTY){
    direction = EMPTY
 return(direction)   
}

lst = c(np, ep, sp, wp)
# don't allow ant to turn to previous cell, so make value artificially
# small

if (site < STAY){
    lst[site] = -2
}

# don't allow ant to turn to cell with another ant, so make value
# artificially small 

neighbors = c(na, ea, sa, wa)
for(i in 1:4){

    if (neighbors[i] > 0){
        lst[i] = -2
    }
}

mx = max(lst)
if (mx < 0){
    direction = STAY
 }
else{
	posList = which(lst == mx)
    lng = length(posList)
	rndPos = ceiling(runif(1,0,lng))   
	direction = posList[rndPos]
     }
return(direction)
}
