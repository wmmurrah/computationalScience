function grids = diffusionSim(m, n, diffusionRate, hotSites, coldSites, t)
% DIFFUSIONSIM Diffusion simulation
global AMBIENT HOT COLD 
AMBIENT = 25; HOT = 50; COLD = 0;
%%% Initialize grid
bar=initBar(m, n, hotSites, coldSites);

%%% Perform simulation
grids = zeros(m, n, t + 1);
grids(:, :, 1) = bar;
for i = 2:(t + 1)
    % Extend matrix
    barExtended = reflectingLat(bar);
    % Apply spread of heat function to each grid point
    bar = applyDiffusionExtended(diffusionRate, barExtended);
    % reapply hot and cold spots
    bar=applyHotCold(bar, hotSites, coldSites);
    % Save new matrix
    grids(:, :, i) = bar;
end;