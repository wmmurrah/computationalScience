% Social Networks

clear all
close all
clc

%% Connection Matrix
% read file
% Household ID	Person ID	Activity ID	Purpose	Start Time	Duration	Location
activities = load('sample_activities.dat');
%%%activities = [4 7 1 0 0 13950 2938; 4 7 2 1 27000 17550 27618; 4 7 3 4 64800 29250 2938; 4 8 4 0 0 17400 2938; 4 8 5 2 34200 3060 6270; 4 8 6 2 38400 3060 21032; 4 8 7 0 43200 3150 2938; 4 8 8 2 47099 4215 15370; 4 8 9 4 54299 34500 2938; 5 9 1 0 0 13350 10628; 5 9 2 1 25800 19049 29740; 5 9 3 4 61800 30749 10628; 6 18 25 0 0 15300 2938; 6 18 26 7 30600 18149 5212; 6 18 27 4 65700 1800 2938; 6 18 28 2 67860 2388 19815; 6 18 29 0 70499 26400 2938];
%%%activities = load('activities-portland-1-v1.dat');

% generate list of nodes for people, identified by integer
maxPersonId = activities(end, 2)
personIdLst = 1:maxPersonId;

% get list of locations
genLocIDLst = @(activities)  unique(activities(:, 7)');

locationIDLst = genLocIDLst(activities);

% function to return index of location in locationIDLst
index(8159, locationIDLst)

% generate adjacency matrix with people indices as row labels and 
% location indices as column labels
% genPeopleLocConnMat - function to generate people-to-location graph
connMat = genPeopleLocConnMat( maxPersonId, locationIDLst, activities );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Minimum dominating set problem

% function to return the degree of a location node
degLocation = @(j) sum(connMat(:, j));

% list of ordered pairs of location index & corresponding degree
lst = 1:length(locationIDLst);
locDegPairLst = [lst; degLocation(lst)]'

% function to return lst sorted by the second members of the ordered pairs
sortSecond = @(lst) sortrows(locDegPairLst, -2)

sortSecond(locDegPairLst)

% Function to return list of personIDs adjacent to location loc
adjacentPeopleLst = @(loc) find(connMat(:, loc) == 1)';

adjacentPeopleLst(3)
adjacentPeopleLst(4)
for i=1:52
    adjacentPeopleLst(i)
end

% test
locations = minDominating(locationIDLst, connMat, 1)
length(locations)

% test
locations = minDominating(locationIDLst, connMat, 0.5)
length(locations)

% test
locations = minDominating(locationIDLst, connMat, 0.75)
length(locations)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% People-to-people graph and  degree distribution of people-to-people graph
connPeopleMat = peopleToPeople(connMat);

% use function to return the degree of a person node in people-to-people graph
distribLst = degPersonPPG(connPeopleMat, 1:maxPersonId)

hist(distribLst)

% average degree
mean(distribLst)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clustering coefficient

% Function to return list of personIDs adjacent to person v in person-to-person 
% graph
adjacentPeople = @(connPeopleMat, v) find(connPeopleMat(v,:));

% test function
for i = 1:maxPersonId
    adjacentPeople(connPeopleMat, i)
end

adjacentPeople(connPeopleMat, 18)

% Test of function to return the number of edges  in a set in person-to-person graph
numPeopleEdges( connPeopleMat, [1 2 3])

clusteringCoeff(connPeopleMat, 18)

coeffLst = [];
for i = 1:18
    coeffLst = [coeffLst, clusteringCoeff(connPeopleMat, i)];
end;
coeffLst
mean(coeffLst)