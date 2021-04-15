function showWalk(lst)
%%% SHOWWALK - visualization of random walk
% Pre:	lst is the list of the points in the walk.

xStepLst = lst(:, 1);
yStepLst = lst(:, 2);

minX = min(xStepLst);
maxX = max(xStepLst);
minY = min(yStepLst);
maxY = max(yStepLst);
lng = length(xStepLst);
plot(xStepLst, yStepLst, 'ok-', ...
    'MarkerFaceColor', 'b', 'MarkerSize', 12);
hold on;
plot([xStepLst(lng)], [yStepLst(lng)], 'ok', ...
   'MarkerFaceColor', 'k', 'MarkerSize', 12);
axis([minX maxX minY maxY]);
axis equal;
hold off;  