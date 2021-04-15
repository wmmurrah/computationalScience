function [ newNutrientGrid ] = applyDiffusionExtended( matExt, diffusionRate )
%APPLYDIFFUSION applies diffusion function to each grid cell
%   newNutrientGrid ] = applyDiffusion( nutrientGrid, diffusionRate )
%   takes nutrientGrid (matrix) and diffusionRate and returns the grid 
%   with the function diffusion applied to each element of the original grid 
m = size(matExt, 1) - 2;
n = size(matExt, 2) - 2;
newNutrientGrid = zeros(m, n);
for i = 2:(m+1)
    for j = 2:(n+1)
        site = matExt(i, j);
        N = matExt(i-1, j);
        NE = matExt(i-1, j+1);
        E = matExt(i, j+1);
        SE = matExt(i+1, j+1);
        S = matExt(i+1, j);
        SW = matExt(i+1, j-1);
        W = matExt(i, j-1);
        NW = matExt(i-1, j-1);
        newNutrientGrid(i-1, j-1) = diffusion(diffusionRate, site, N, NE, E, SE, S, SW, W, NW);
    end
end

end

