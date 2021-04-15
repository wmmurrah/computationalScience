function M = animateWalk(lst)
%%% ANIMWALK - animation of random walk
% Pre:	lst is the list of the points in the walk.

clf;
xStepLst = lst(:, 1);
yStepLst = lst(:, 2);

minX = min(xStepLst);
maxX = max(xStepLst);
minY = min(yStepLst);
maxY = max(yStepLst);
lng = length(xStepLst);
for i = 1:lng
    p = plot(xStepLst(1:i), yStepLst(1:i), 'ok-', ...
        'MarkerFaceColor', 'b', 'MarkerSize', 9);
    axis([minX maxX minY maxY]);
    axis equal;
    hold on;
    plot([xStepLst(i)], [yStepLst(i)], 'ok', ...
        'MarkerFaceColor', 'k', 'MarkerSize', 12);
    axis([minX maxX minY maxY]);
    axis equal;
    M(i) = getframe;
    hold off;
end;   