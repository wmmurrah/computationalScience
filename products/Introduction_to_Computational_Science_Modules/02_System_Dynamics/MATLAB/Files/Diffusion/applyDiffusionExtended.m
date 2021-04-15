function newLat = applyDiffusionExtended(diffusionRate, latExt)
% APPLYEXTENDED - Function to apply 
% diffusion(diffusionRate, site, N, NE, E, SE, S, SW, W, NW)
% site of matrix latExt and to return the resulting matrix
m = size(latExt, 1) - 2;
n = size(latExt, 2) - 2;
newLat = zeros(m, n);    
% calculate one column at a time because MATLAB is column-oriented
for j = 2:(n + 1)
    for i = 2:(m + 1)
        site = latExt(i, j);
        N = latExt(i - 1, j);
        NE = latExt(i - 1, j + 1);
        E = latExt(i, j + 1);
        SE = latExt(i + 1, j + 1);
        S = latExt(i + 1, j);
        SW = latExt(i + 1, j - 1);
        W = latExt(i, j - 1);
        NW = latExt(i - 1, j - 1);
        newLat(i - 1, j - 1) = ...
            diffusion(diffusionRate, site, N, NE, E, SE, S, SW, W, NW);
    end;
end;