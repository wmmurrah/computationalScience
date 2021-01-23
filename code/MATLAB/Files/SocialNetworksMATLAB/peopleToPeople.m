function [ adjPeopleMat ] = peopleToPeople( adjMat )
%PERSONTOPERSON generate adjacency matrix for a people-to-people graph
%   Given a people-to-location adjacency matrix (adjMat),
%   the function returns the corresponding people-to-people matrix.

maxPersonId = size(adjMat, 1);
adjPeopleMat = zeros(maxPersonId);
for loc = 1:size(adjMat, 2)
    for i = 1:maxPersonId
        if (adjMat(i, loc) == 1)
            for j = (i + 1):maxPersonId
                if (adjMat(j, loc) == 1)
                    adjPeopleMat(i, j) = 1;
                    adjPeopleMat(j, i) = 1;
                end;
            end
        end
    end
end
end

