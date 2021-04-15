function M = showGraphs(graphList)
% SHOWGRAPHS - Function to return movie visualization 
% of grids in graphList
map = [1 1 0;        % EMPTY   -> yellow
    0.1 0.75 0.2;    % TREE    -> forest green
    0.6 0.2 0.1];    % BURNING -> burnt orange
colormap(map);
m = size(graphList, 3);
for k = 1:m
    g = graphList(:, :, k);
    image(g + 1)
    axis off
    axis square
    M(k) = getframe;
end;