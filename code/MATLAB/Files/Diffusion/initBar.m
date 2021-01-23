function bar = initBar(m, n,hotSites, coldSites)
% INITBAR return m-by-n bar initialized with all ambient temperatures
% except for hot and cold sites
global AMBIENT

bar = AMBIENT * ones(m, n);
bar = applyHotCold(bar, hotSites, coldSites);