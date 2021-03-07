function [area circum] = squareStats(side)
% SQUARESTATS Area and circumference of a square
%    squareStats(side) returns a vector with the area and
%    circumference of a square with length of a side equal to side.
area = side * side;
circum = 4 * side;
end
