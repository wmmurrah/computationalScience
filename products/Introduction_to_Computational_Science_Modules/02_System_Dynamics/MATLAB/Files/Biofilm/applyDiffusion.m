function [ newNutrientGrid ] = applyDiffusion( nutrientGrid, diffusionRate )
%APPLYDIFFUSION applies diffusion function to each grid cell
%   newNutrientGrid ] = applyDiffusion( nutrientGrid, diffusionRate )
%   takes nutrientGrid (matrix) and diffusionRate and returns the grid 
%   with the function diffusion applied to each element of the original grid 
newNutrientGrid = nutrientGrid;
n = length(nutrientGrid);
for i = 2:(n-1)
    for j = 2:(n-1)
        site = nutrientGrid(i, j);
        N = nutrientGrid(i-1, j);
        NE = nutrientGrid(i-1, j+1);
        E = nutrientGrid(i, j+1);
        SE = nutrientGrid(i+1, j+1);
        S = nutrientGrid(i+1, j);
        SW = nutrientGrid(i+1, j-1);
        W = nutrientGrid(i, j-1);
        NW = nutrientGrid(i-1, j-1);
        newNutrientGrid(i, j) = diffusion(diffusionRate, site, N, NE, E, SE, S, SW, W, NW);
    end
end

end

