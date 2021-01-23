function newmat = applyExtended(latExtended, probLightning, probImmune)
% APPLYEXTENDED - Function to apply 
% spread(site, N, E, S, W, probLightning, probImmune) to every interior
% site of square array latExt and to return the resulting array
n = size(latExtended, 1) - 2;
newmat = zeros(n);    
for j = 2:(n + 1)
    for i = 2:(n + 1)
        site = latExtended(i, j);
        N = latExtended(i - 1, j);
        E = latExtended(i, j + 1);
        S = latExtended(i + 1, j);
        W = latExtended(i, j - 1);
        newmat(i - 1, j - 1) = spread(site, N, E, S, W, probLightning, probImmune);
    end;
end;