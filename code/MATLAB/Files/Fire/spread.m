function newSite = spread(site, N, E, S, W, probLightning, probImmune)
% SPREAD - Function to return the value of a site
% at the next time step
% An empty cell remains empty.
% A burning cell becomes empty.
% If a neighbor to the north, east, south, or west of 
% a tree is burning, then the tree does not burn with a
% probability of probImmune.
% If a tree has no burning neighbors, it is hit by lightning
% and burns with a probability of probLightning * (1 - probImmune).
%
global EMPTY TREE BURNING 

% EMPTY = 0; TREE = 1; BURNING = 2;
if site == EMPTY
    newSite = EMPTY;
elseif site == BURNING
    newSite = EMPTY;
else
    if (N==BURNING || E==BURNING || S==BURNING || W==BURNING)
        if (rand < probImmune)
            newSite = TREE;
        else
            newSite = BURNING;
        end;
    elseif (rand < probLightning * (1 - probImmune))
        newSite = BURNING;
    else
        newSite = TREE;
    end;
end;