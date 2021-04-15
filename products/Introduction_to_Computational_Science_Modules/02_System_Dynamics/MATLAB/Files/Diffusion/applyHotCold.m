function bar = applyHotCold(bar, hotSites, coldSites)
% APPLYHOTCOLD return bar with hot and cold sites
global HOT COLD 

for k = 1:size(hotSites, 1)
    bar(hotSites(k, 1), hotSites(k, 2)) = HOT;
end;

for k = 1:size(coldSites, 1)
    bar(coldSites(k, 1), coldSites(k, 2)) = COLD;
end;