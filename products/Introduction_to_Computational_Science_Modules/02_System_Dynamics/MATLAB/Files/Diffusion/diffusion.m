function r = diffusion(diffusionRate, site, N, NE, E, SE, S, SW, W, NW)
% DIFFUSION new value at cell due to diffusion

r = (1 - 8*diffusionRate)*site + diffusionRate*(N+NE+E+SE+S+SW+W+NW);