function [ locations ] = minDominating( locationIDLst, connMat, percentPeople )
%MINDOMINATING return partial minimum dominating set to cover percent fraction of the 
%people using FastGreedy Algorithm
%   Given location ids (locationIDLst), people-to-location matrix (connMat)    
%   and a percentage (percentPeople), the function uses the FastGreedy Algorithm
%   to compute a set of locations ids (locations), where
%   percentPeople of all the people go to those locations.  The function
%   returns locations.

if (percentPeople < 0 || percentPeople > 1)
    percentPeople = 1;
end

% function to return the degree of a location node
degLocation = @(j) sum(connMat(:, j));

% list of ordered pairs of location index & corresponding degree
lst = 1:length(locationIDLst);
locDegPairLst = [lst; degLocation(lst)]';

% function to return lst sorted by the second members of the ordered pairs
sortSecond = @(lst) sortrows(locDegPairLst, -2);
sortedLocDegPairLst = sortSecond(locDegPairLst);

% Function to return list of personIDs adjacent to location loc
adjacentPeopleLst = @(loc) find(connMat(:, loc) == 1)';

people = [];
locations = [];
locDegPair = 1;
percentLength = percentPeople * size(connMat, 1);
while (length(people) < percentLength)
    pair = sortedLocDegPairLst(locDegPair, 1:2);
    locIndex = pair(1);
    locDeg = pair(2);
    loc = locationIDLst(locIndex);
    locations = union(locations, [loc]);
    people = union(people, adjacentPeopleLst(locIndex));
    locDegPair = locDegPair + 1;    
end

end

