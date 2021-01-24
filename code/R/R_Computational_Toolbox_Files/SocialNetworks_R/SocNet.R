# Social Networks

################################################################################################################
# read file
# Household ID	Person ID	Activity ID	Purpose	Start Time	Duration	Location
activities = as.matrix(read.table('sample_activities.dat'));
###activities = as.matrix(read.table('activities-portland-1-v1.dat'));

# generate list of nodes for people, identified by integer

maxPersonId = activities[nrow(activities),2]
personIdLst = 1:maxPersonId;

# get list of locations

###locationIDLst = genLocIDLst(activities);
locationIDLst = t(unique(activities[1:nrow(activities),7]));

# function to return index of location in locationIDLst
locationIndex<-function( loc, locationIDLst ) {
   return(which(locationIDLst == loc))
}

locationIndex(8159, locationIDLst)

# generate adjacency matrix with people indices as row labels and 
# location indices as column labels
# genPeopleLocConnMat - function to generate people-to-location graph
# adjMat = genPeopleLocConnMat( maxPersonId, locationIDLst, activities )
connMat = genPeopleLocConnMat( maxPersonId, locationIDLst, activities )

################################################################################################################

## MINIMUM DOMINATING SET PROBLEM

# function to return the degree of a person node

degPerson<-function(i) {
	return (sum(adjMat[i, 1:ncol(adjMat)]))
	}

# function to return the degree of a location node
degLocation<-function(j) {
	#return (sum(adjMat[1:nrow(adjMat), j])) ### this line had adjMat in the previous one and now it is connMat, is that a change?
	return (sum(connMat[1:nrow(connMat), j]))
	}

# list of ordered pairs of location index & corresponding degree
lst = 1:length(locationIDLst)
locDegPairLst = matrix(0,nrow=length(locationIDLst),ncol=2)

for (i in 1:length(locationIDLst)) {
    locDegPairLst[i,1] = i
    locDegPairLst[i,2] = degLocation(i)
}
print(locDegPairLst)

## function to return lst sorted by the second members of the ordered pairs
sortSecond <-function(locaDegPairLst){return(locDegPairLst[order(locDegPairLst[,2]),])
}


## Function to return list of personIDs adjacent to location loc

adjacentPeopleLst<-function(loc){
	 #return(t(which(adjMat[,loc]==1)))
	 return(t(which(connMat[,loc]==1)))
		}
adjacentPeopleLst(3)
adjacentPeopleLst(4)
 for (i in 1:52){
     adjacentPeopleLst(i)}

# test
locations = minDominating(locationIDLst,connMat,1)
length(locations)
print(locations)
# test 
locations = minDominating(locationIDLst,connMat,0.5)
length(locations)
print(locations)
# test
locations = minDominating(locationIDLst,connMat,0.75)
length(locations)
print(locations)



##################################################################################
#### People-to-people graph and degree distribution of people-to-people graph

#adjPeopleMat = personToPerson(adjMat)
#adjPeopleMat = personToPerson(adjMat)
connPeopleMat = peopleToPeople(connMat)

##use function to return the degree of a person node in people-to-people graph
#distribLst = degPersonPPG(adjPeopleMat, 1:maxPersonId)
distribLst = c()
for (i in 1:maxPersonId){
	distribLst = append(distribLst,degPersonPPG(connPeopleMat,i))
			}

#print(distribLst)
hist(distribLst,col="grey")

# # average degree
 mean(distribLst)    

# #################################################################################
# ######## Clustering coefficient

## Function to return list of personIDs adjacent to person v in person-to-person 
## graph
# adjacentPeople = @(adjPeopleMat, v) find(adjPeopleMat(v,:));-->>ask about this one as well???


adjacentPeople <-function(connPeopleMat, v) { #adjPeopleMat[v,]

return(which(connPeopleMat[v,]==1))
}

                      print(adjacentPeople(connPeopleMat,1))
for (i in 1:maxPersonId){
     adjacentPeople(connPeopleMat, i)
 }

 adjacentPeople(connPeopleMat, 18)


## Test of function to return the number of edges  in a set in person-to-person graph
# numPeopleEdges( adjPeopleMat, [1 2 3])

numPeopleEdges(connPeopleMat, c(1, 2, 3))

clusteringCoeff(connPeopleMat, 18)

 coeffLst = c();
 for (i in 1:18){
     #coeffLst = [coeffLst, clusteringCoeff(adjPeopleMat, i)];
     coeffLst = 0#cbind(coeffLst, clusteringCoeff(adjPeopleMat, i));
    }
coeffLst
mean(coeffLst)
