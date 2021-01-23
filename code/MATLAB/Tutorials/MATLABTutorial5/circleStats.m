function [area circumference] = circleStats(r)
%CIRCLESTATS area and circumference of a circle
%   circleStats(r) returns the area and circumference of a circle
%   with radius r
area = pi .* r .* r;
circumference = 2 * pi .* r;
end

