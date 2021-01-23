% File testFire.m
% Script to test grids = fire(n, probTree, probBurning, probLightning, probImmune, t)
%%
rand('seed', 1)
grids = fire(15, 0.8, 0.001, 0.001, 0.3, 20);
M = showGraphs(grids)
% movie(M, 1)

%%
% probLightning = 0
% probImmune = 0
fireList =fire(20, 0.5, 0.5,0.5, 0.5, 5);
M = showGraphs(fireList)

%%
% probLightning small
% probImmune = 0
fireList = fire(20,0.3,0.01,0,0,15);
M = showGraphs(fireList)

%%
% probLightning = 0
% probImmune = 0.52
fireList = fire(20,0.3,0.2,0,0.52,25);
M = showGraphs(fireList)

