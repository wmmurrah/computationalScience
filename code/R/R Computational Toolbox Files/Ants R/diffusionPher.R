#Callixte Nahimana
#October 27 2013
#function pherValue to return the phermont value 

diffusionPher<-function(diffusionRate, site, N, NE, E, SE, S, SW, W, NW){

pherValue = (1 - 8*diffusionRate)*site + diffusionRate*(N + NE + E + SE + S + SW + W + NW)

return(pherValue)

}
