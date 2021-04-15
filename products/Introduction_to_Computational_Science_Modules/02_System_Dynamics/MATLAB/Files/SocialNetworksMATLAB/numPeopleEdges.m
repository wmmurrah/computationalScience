function [ numEdges ] = numPeopleEdges( connPeopleMat, vertices )
%NUMPEOPLEEDGES returns the number of edges  in a set in person-to-person graph
%   Given a person-to-person graph (connPeopleMat) and a vector of indices
%   (vertices),  the function returns the number of edges (numEdges) in the subgraph
%   with vertices.

subMat = connPeopleMat(vertices, :);
numEdges = sum(sum(subMat(:, vertices)))/2;
end

