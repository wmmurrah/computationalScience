% testDiffusion.m
% Script for two tests of diffusion simulation
%% Test 1
global AMBIENT HOT COLD 
AMBIENT = 25.0;
HOT = 50.0;
COLD = 0.0;

m=3;
n=5;
diffusionRate=0.1;
hotSites=[2,1];
coldSites=[3,5];
t=2;

% testing individual functions
% bar=initBar(m, n,hotSites, coldSites);
% diffusion(diffusionRate, 10, 30, 40, 0,0,0,0,0,0)
% barExt = reflectingLat(bar)
% newBar = applyDiffusionExtended(diffusionRate,barExt)

grids = diffusionSim(m,n,diffusionRate, hotSites, coldSites,t);
%%
figure
M = animDiffusionColor(grids)
%%
M = animDiffusionGray(grids)

%% Test 2
m=20;
n=60;
diffusionRate=0.05;
hotSites=[[floor(m/2)-1,1];[floor(m/2),1];[floor(m/2)+1,1];[1,floor(3*n/4)]];
coldSites=[[m,floor(n/3)-1];[m,floor(n/3)];[m,floor(n/3)+1];[m,floor(n/3)+2];[m,floor(n/3)+3]];
t=500;

grids = diffusionSim(m, n, diffusionRate, hotSites, coldSites, t);
%%
M = animDiffusionColor(grids)
%%
M = animDiffusionGray(grids)
