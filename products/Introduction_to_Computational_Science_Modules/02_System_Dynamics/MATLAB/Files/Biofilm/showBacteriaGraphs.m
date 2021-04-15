function [ playBac ] = showBacteriaGraphs(bacGrids)
%SHOWBAC - Function to return a movie visualization of grids in 3-dimensional
%array bacGrids

t = size(bacGrids, 3);
map = [1 1 0;           %EMPTY, yellow
       0 1 0;           %BACTERIA, green
    0.5 0.5 0.5];       %DEAD, gray
    
colormap(map);    

for k = 1:t
    g = bacGrids(:, :, k);
    image(g + 1)
    axis off
    playBac(k) = getframe;
end


end

