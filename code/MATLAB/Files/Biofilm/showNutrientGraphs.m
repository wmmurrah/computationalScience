function [ playNut ] = showNutrientGraphs(nutGrids)
%SHOWNUT - Function to return a movie visualization of grids in 3-dimensional
% array nutGrids
%   Nutrient values are represented in a gray scale: the lighter the value
%   the smaller the nutrient value 
global MAXNUTRIENT

colormap(gray(10));
t = size(nutGrids, 3);
for k = 1:t
    g = nutGrids(:, :, k);
    image(10*(1 - g/MAXNUTRIENT));
    axis off
    playNut(k) = getframe;
end
    
end

