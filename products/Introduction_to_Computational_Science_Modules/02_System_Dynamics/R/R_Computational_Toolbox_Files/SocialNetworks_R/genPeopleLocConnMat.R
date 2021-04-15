genPeopleLocConnMat<-function( maxPersonId, locs, activities ) {
#GENPEOPLELOCADJMAT function to generate people-to-location graph
#   Function returns adjacency matrix with people indices as row labels 
#   and location indices as column labels

connMat = matrix(0,maxPersonId,length(locs))
for (i in 1:nrow(activities)) {
    connMat[activities[i, 2], locationIndex(activities[i, 7], locs)] = 1
}
return (connMat)
}

