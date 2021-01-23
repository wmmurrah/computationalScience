global MAXNUTRIENT CONSUMED EMPTY BACTERIUM DEAD BORDER USED
 
MAXNUTRIENT = 1.0;
CONSUMED = 0.1;
EMPTY = 0;
BACTERIUM = 1;
DEAD = 2;
BORDER = 3;
USED = 4; 

[bacGrids, nutGrids] = biofilm(10, 10, .5, .1, 1, 40);
playBac = showBacteriaGraphs(bacGrids)
figure;
playNut = showNutrientGraphs(nutGrids)

%% another test
[bacGrids, nutGrids] = biofilm(50, 20, .5, .1, 1, 130);
figure;
playBac = showBacteriaGraphs(bacGrids)
figure;
playNut = showNutrientGraphs(nutGrids)

%% another test
[bacGrids, nutGrids] = biofilm(50, 20, .5, .1, 0.3, 130);
figure;
playBac = showBacteriaGraphs(bacGrids)
figure;
playNut = showNutrientGraphs(nutGrids)

%% another test
[bacGrids, nutGrids] = biofilm(50, 50, 0.25, 0.05, 0.5, 100);
figure;
playBac = showBacteriaGraphs(bacGrids)
figure;
playNut = showNutrientGraphs(nutGrids)
