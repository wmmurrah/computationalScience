% MATLAB Tutorial 6
% File:  MATLABTutorial6Ans.m

%% QRQ 1 a
mat = [1 2 3; 4 5 6; 7 8 9]
mat(:, 3)

%% QRQ 1 b
[mat(:, 3) mat]

%% QRQ 2 a
mat(3, :)

%% QRQ 2 b
[mat(3, :); mat]

%% QRQ 3 a
extendRows = [mat(3, :); mat; mat(1, :)]

%% QRQ 3 b
extendCols = [extendRows(:, 3) extendRows extendRows(:, 1)]

%% QRQ 4 
lst = zeros(randi(11) + 4, randi(4))
% or
lst = zeros(randi([5,15]), randi(4))

%% QRQ 4 a
size(lst, 1)

%% QRQ 4 b
size(lst, 2)

%% QRQ 5 a
randMat = randi(4, 10, 10)

%% QRQ 5 b
colormap(gray(4))
image(randMat)
axis off
axis square

%% QRQ 5 c
map = zeros(4, 3);

%% QRQ 5 d
for i = 1:4
    map(i, :) = [i/4 0 0]; % or  map(i,1) = i/4
end;

%% QRQ 5 e
colormap(map);

%% QRQ 5 f
image(randMat)
axis off
axis square

%% QRQ 6 a
mc = zeros(10);
for j = 1:10
     mc(:, j) = j;
end;  

% or

mc = [];
row = 1:10;
for j=1:10
     mc=[mc; row];
end;

%% QRQ 6 b
map = zeros(10, 3);
for i = 1:10
    map(i, :) = [(i - 1) * 0.1, (i - 1) * 0.1, 0];  % or map(i, 1:2) = i/10;
end;
colormap(map);
image(mc)
axis off
axis square

%% QRQ 7 a
mc2 = zeros(100);
for j = 1:100
     mc2(:, j) = j;
end;  

%% QRQ 7 b
map = zeros(100, 3);
for i = 1:100
    map(i, :) = [(i - 1) * 0.01, (i - 1) * 0.01, 0];
end;
% or
map2(:,1) = (0:0.01:0.99);
map2(:,2) = (0:0.01:0.99);

colormap(map);
image(mc2)
axis off
axis square

%% QRQ 8 a
mcList = zeros(10,10,6);

%% QRQ 8 b
mcList(:,:,1) = mc;

%% QRQ 8 c
for i = 1:5
mcList(:, :, i + 1) = mc + i;
end

%% QRQ 8 d
map = zeros(15, 3);
for i = 0:14
map(i + 1, :) = [i/15 i/15 0];
end
% or
map = zeros(15, 3);
map(:,1) = [0:1/15:14/15];
map(:,2) = [0:1/15:14/15];


%% QRQ 8 e
colormap(map)
for k = 1:6
image(mcList(:, :, k));
axis off;
axis square;
M(k) = getframe;
end;
movie(M, 3)  % to show animation 3 times

%% QRQ 9 a
ra = rand(3)

%% QRQ 9 b
ra < 0.5

%% QRQ 10
ages = randi(3, 1, 10) + 20
% or
ages = randi([21, 23], 1, 10)

pos21 = find(ages == 21)

%% QRQ 11
weight = randi(151, 1, 10) + 99
% or
weights = randi([100, 250], 1, 10)

weight(pos21)
