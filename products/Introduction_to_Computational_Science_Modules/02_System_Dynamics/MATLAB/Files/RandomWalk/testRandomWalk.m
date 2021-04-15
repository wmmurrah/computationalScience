% Random Walk test file for Module 9.5
% Introduction to Computational Science:  Modeling and Simulation for the Sciences, 2nd Edition
% Angela B. Shiflet and George W. Shiflet
% Wofford College
% � 2014 by Princeton University Press

%% generate and show random walk
rand('seed', sum(100*clock))
lst = randomWalkPoints(25)

showWalk(lst)

%% show animation of random walk
M = animateWalk(lst)

%%
movie(M, 1, 2)

%% Distance covered in a random walk
randomWalkDistance(25)

%% Average over many runs to find average distance 
% between first and last points
meanRandomWalkDistance(25,100)