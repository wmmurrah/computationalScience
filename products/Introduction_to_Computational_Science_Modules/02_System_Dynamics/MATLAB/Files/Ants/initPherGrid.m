function grid = initPherGrid(n)
% INITPHERGRID - initialization of n+2-by-n+2 array for pheromone distribution
global MAXPHER

grid = zeros(n+2, n+2);
mid = round(n/2) + 1;
for i = 1:n
    grid(mid, i+1) = MAXPHER * i / n;
end