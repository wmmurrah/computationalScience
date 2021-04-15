function [ deg ] = degPersonPPG(adjPeopleMat, i )
%DEGPERSONPPG returns the degree of a person node in people-to-people graph
%   Given a people-to-people matrix (adjPeopleMat) and an index i, 
%   the function returns the degree of that node.

deg = sum(adjPeopleMat(i,:));

end

