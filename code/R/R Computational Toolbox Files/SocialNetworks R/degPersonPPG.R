# Callixte Nahimana
# Wofford College, Spartanburg, SC
# April, 18 2014

degPersonPPG<-function(adjPeopleMat, i ){
#DEGPERSONPPG returns the degree of a person node in people-to-people graph
#   Given a people-to-people matrix (adjPeopleMat) and an index i, 
#   the function returns the degree of that node.

return(sum(adjPeopleMat[i,]));
}

