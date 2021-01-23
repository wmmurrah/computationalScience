function [ a,b ] = pickNeighbor(i, j, m, N, E, S, W)
%PICKNEIGHBOR returns a randomly selected empty neighbor
%       pickNeighbor(i,j,m,N,E,S,W ) returns an empty neighbor of (i,j) or
%       (i,j) if none of the neighbors are empty; 
% Pre:	i, j - indices of site in extended bacteria grid
% 	m - number of rows of un-extended bacteria grid
% 	N, E, S, W - values of nearest four neighbors of site in extended bacteria grid

global EMPTY
lst= [N, E, S, W];
pos = find(lst == EMPTY);
newi= i - 1;
newj= j - 1;
if length(pos) == 0
    a = newi;
    b = newj;
else 
    r = randi(length(pos));
    if pos(r) == 1
        if newi > 1
            a = newi - 1;
            b = newj;
        else 
            a = m;
            b = newj;
        end
    elseif pos(r) == 2
            a = newi;
            b = newj + 1;
    elseif pos(r) == 3
        if newi < m
            a = newi + 1;
            b = newj;
        else
            a = 1;
            b = newj;
        end
    else 
        a = newi;
        b = newj - 1;
    end
end
end

