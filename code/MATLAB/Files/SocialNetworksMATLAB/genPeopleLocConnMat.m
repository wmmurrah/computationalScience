function [ connMat ] = genPeopleLocConnMat( maxPersonId, locs, activities )
%GENPEOPLELOCCONNMAT function to generate people-to-location graph
%   Function returns adjacency matrix with people indices as row labels 
%   and location indices as column labels

connMat = zeros(maxPersonId, length(locs));
for i = 1:length(activities)
    connMat(activities(i, 2), index(activities(i, 7) , locs)) = 1;
end

end

