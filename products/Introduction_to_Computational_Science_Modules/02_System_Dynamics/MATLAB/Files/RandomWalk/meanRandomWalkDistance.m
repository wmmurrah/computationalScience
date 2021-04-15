function avgDist = meanRandomWalkDistance(n, numTests)
% RANDOMWALK  Function to return average distance
% between first and last point in random walk of
% n steps, where the simulation is performed
% numTests number of times
sumDist = 0;
for j = 1:numTests
    sumDist = sumDist + randomWalkDistance(n);
end;
avgDist = sumDist/numTests;