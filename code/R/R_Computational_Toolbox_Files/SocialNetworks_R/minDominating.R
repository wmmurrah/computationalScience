minDominating<-function (locationIDLst,connMat, percentPeople ){
#MINDOMINATING return partial minimum dominating set to cover percent fraction of the 
#people using FastGreedy Algorithm
#   Given people-to-location matrix (adjMat)
#   lists of person ids (personIdLst) and location ids (locationIDLst) 
#   and a percentage (percentPeople), the function uses the FastGreedy Algorithm
#   to compute a set of people ids (people) and locations ids (locations), where
#   percentPeople of all the people go to those locations.  The function
#   returns [ people, locations ]

if (percentPeople < 0 || percentPeople > 1)
    percentPeople = 1;

# function to return the degree of a location node


## degPerson = @(i) sum(adjMat(i, :));
degLocation<-function(j) {
        return (sum(connMat[1:nrow(connMat), j])) 
        }

# list of ordered pairs of location index & corresponding degree
#lst = 1:length(locationIDLst);
#locDegPairLst = [lst; degLocation(lst)]';

lst = 1:length(locationIDLst)
locDegPairLst = matrix(0,nrow=length(locationIDLst),ncol=2)

for (i in 1:length(locationIDLst)) {
    locDegPairLst[i,1] = i
    locDegPairLst[i,2] = degLocation(i)
}

#function to return lst sorted by the second members of the ordered pairs

#sortSecond = @(lst) sortrows(locDegPairLst, -2);
#sortedLocDegPairLst = sortSecond(locDegPairLst);

sortSecond <-function(locaDegPairLst){
	return(locDegPairLst[order(locDegPairLst[,2]),])
					}
sortedLocDegPairLst = sortSecond(locDegPairLst)

# Function to return list of personIDs adjacent to location loc

#adjacentPeopleLst = @(loc) find(connMat(:, loc) == 1)';

adjacentPeopleLst<-function(loc){
         return(t(which(connMat[,loc]==1)))
	}

people = c();
locations = c();
locDegPair = 1;
percentLength = percentPeople * length(personIdLst);

while (length(people) < percentLength){
    pair = sortedLocDegPairLst[locDegPair, 1:2];
    locIndex = pair[1];
    locDeg = pair[2];
    loc = locationIDLst[locIndex];
    locations = union(locations, loc);
    people = union(people, adjacentPeopleLst(locIndex));
    locDegPair = locDegPair + 1   
 }
return(locations)
}

