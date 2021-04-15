function M = animDiffusionGray(grids)
% ANIMDIFFUSIONGRAY - Function to return grayscale movie visualization 
% of grids in grids
global HOT  

lengthGrids = size(grids, 3);
M = moviein(lengthGrids);

map = zeros(HOT + 1, 3);
for i = 0:HOT
    amt = i/HOT;
    map(i + 1, :) = [amt, amt, amt];
end; 
colormap(map);

m = size(grids, 1);
n = size(grids, 2)

for k = 1:lengthGrids
    g = grids(:, :, k);
    image(HOT - g + 1);
    colormap(map);

    axis([0 m 0 n]);
    axis equal;
    axis off;
    drawnow;
    M(k) = getframe;
end;
