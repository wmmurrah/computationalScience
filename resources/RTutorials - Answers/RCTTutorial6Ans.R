# MATLAB Tutorial 6
# File:  MATLABTutorial6Ans.m

## QRQ 1 a
mat = matrix(1:9, nrow = 3)
mat[, 3]

## QRQ 1 b
cbind(mat[, 3], mat)

## QRQ 2 a
mat[3, ]

## QRQ 2 b
rbind(mat[3,], mat)

## QRQ 3 a
xtendRows = rbind(mat[3,], mat, mat[1,])

## QRQ 3 b
extendCols = cbind(extendRows[, 3], extendRows, extendRows[, 1])

## QRQ 4 a 
lst = matrix(rep(0), nrow = floor(runif(1, 5, 16)), 
              ncol = floor(runif(1, 1, 5)))
dim(lst)

## QRQ 4 b
nrow(lst)

## QRQ 4 c
ncol(lst)

## QRQ 5 a
randMat = matrix(floor(runif(100, 1, 5)), nrow = 10)

## QRQ 5 b
image(randGrid, col = grey(seq(0, 1, length = 4)), axes = FALSE)box()

## QRQ 5 c
map = c(rgb(1/4, 0, 0), rgb(1/2, 0, 0), rgb(3/4, 0, 0), rgb(1, 0, 0))

## QRQ 5 d
image(randMat, col = map, axes = FALSE)
box()

## QRQ 6 a
mc = c()
for (i in 1:10) {
     mc = cbind(mc, rep(i, 10))
}

## QRQ 6 b
map = c()
for (i in 0:9) {
    map = rbind(map, rgb(i/10, i/10, 0))
}
image(mc, col = map, axes = FALSE)
box()

## QRQ 7 a
mc = c()
for (i in 1:100) {
     mc = cbind(mc, rep(i, 100))
}

## QRQ 7 b
map = c()
for (i in 0:99) {
    map = rbind(map, rgb(i/100, i/100, 0))
}
image(mc, col = map, axes = FALSE)
box()

## QRQ 8 a
mcList = zeros(10,10,6);

## QRQ 8 b
mcList(:,:,1) = mc;

## QRQ 8 c
for i = 1:5
mcList(:, :, i + 1) = mc + i;
end

## QRQ 8 d
map = zeros(15, 3);
for i = 0:14
map(i + 1, :) = [i/15 i/15 0];
end
# or
map = zeros(15, 3);
map(:,1) = [0:1/15:14/15];
map(:,2) = [0:1/15:14/15];


## QRQ 8 e
colormap(map)
for k = 1:6
image(mcList(:, :, k));
axis off;
axis square;
M(k) = getframe;
end;
movie(M, 3)  # to show animation 3 times

## QRQ 9 a
ra = rand(3)

## QRQ 9 b
ra < 0.5

## QRQ 10
ages = randi(3, 1, 10) + 20
# or
ages = randi([21, 23], 1, 10)

pos21 = find(ages == 21)

## QRQ 11
weight = randi(151, 1, 10) + 99
# or
weights = randi([100, 250], 1, 10)

weight(pos21)
