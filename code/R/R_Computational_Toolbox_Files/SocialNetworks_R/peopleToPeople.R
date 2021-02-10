peopleToPeople <-function( adjMat ){
#PERSONTOPERSON generate adjacency matrix for a people-to-people graph
#   Given a people-to-location adjacency matrix (adjMat),
#   the function returns the corresponding people-to-people matrix.
maxPersonId = nrow(adjMat)
print(maxPersonId)
#adjPeopleMat = zeros(maxPersonId);
adjPeopleMat = matrix(c(rep(0,maxPersonId*maxPersonId)),nrow=maxPersonId)
#print(c(nrow(adjPeopleMat),ncol(adjPeopleMat)))
for (loc in 1:ncol(adjMat)){
    for (i in 1:maxPersonId){
        if (adjMat[i, loc] == 1 && (i+1)<maxPersonId){
            for (j in (i + 1):maxPersonId){#ask about this i+1 Error in adjMat[j, loc] : subscript out of bounds
		#print(c(j,loc))
                if (adjMat[j,loc] == 1){
                    adjPeopleMat[i, j] = 1;
                    adjPeopleMat[j, i] = 1;
                }
            }
        }
    }
}
return(adjPeopleMat)
}

