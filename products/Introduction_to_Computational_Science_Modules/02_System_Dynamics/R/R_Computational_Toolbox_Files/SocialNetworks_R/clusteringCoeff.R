# Callixte Nahimana
## Wofford College 429 North church street 
## May,4 2014 

clusteringCoeff <- function (connPeopleMat, v ){
#   CLUSTERINGCOEFF returns the clustering coefficient for a node
#   Given a people-to-people matrix (connPeopleMat) and an index (v)
#   the function returns the clustering coefficient for node v.
#   For a node with 0 or 1 adjacent nodes, the function returns 1.
#   Function to return list of personIDs adjacent to person v in person-to-person 
#   graph

adjacentPeople = function(adjPeopleMat, v){# find(adjPeopleMat(v,:));
return(which(adjPeopleMat[v,]==1))

}


deg = degPersonPPG(connPeopleMat, v);
if (deg < 2){
    coeff = 0
   }
else{
    adj = adjacentPeople(connPeopleMat, v);
    numerator = numPeopleEdges(connPeopleMat, adj);
    denominator = deg*(deg - 1)/2.0;
    coeff = numerator/denominator;
}
return(coeff)
}

