function [ newSite ] = diffusion( diffusionRate, site, N, NE, E, SE, S, SW, W, NW )
%DIFFUSION returns the new nutrient value in a cell by diffusion
%   The new value value of the site is the old value of the site plus
%   the diffusionRate times the sum of the difference
%   of each neighbor and the site
newSite = (1 - 8 * diffusionRate)*site + ...
    diffusionRate * (N + NE + E + SE + S + SW + W + NW);

end

