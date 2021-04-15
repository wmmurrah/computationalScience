function [lst] = randomWalkPoints(n)
% RANDOMWALKPOINTS  Function to produce a random walk, where at each time 
% step the entity goes diagonally in a NE, NW, SE, or SW direction, and to
% return a list of the points in the walk
% Pre:	n is the number of steps in the walk.
% Post:	A list of the points in the walk has been returned.
x = 0;
y = 0;
lst = zeros(n + 1,2);
lst(1, :) = [0 0];
for i = 1:n
    if randi([0,1]) == 0
        x = x + 1;
    else
        x = x - 1;
    end;
    if randi([0,1]) == 0
        y = y + 1;
    else
        y = y - 1;
    end;
    lst(i + 1, :) = [x y];
end;    