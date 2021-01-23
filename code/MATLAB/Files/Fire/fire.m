function grids = fire(n, probTree, probBurning, probLightning, probImmune, t)
% FIRE simulation
global EMPTY TREE BURNING
EMPTY = 0; TREE = 1; BURNING = 2;

forest  = initForest( n, probTree, probBurning );
grids = zeros(n, n, t + 1);
grids(:, :, 1) = forest;
for i = 2:(t + 1)
    forestExtended = periodicLat(forest);
    forest = applyExtended(forestExtended, probLightning, probImmune);
    grids(:, :, i) = forest;
end;