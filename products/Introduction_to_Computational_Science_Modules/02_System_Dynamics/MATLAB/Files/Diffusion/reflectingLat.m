function extLat = reflectingLat(lat)
% REFLECTINGLAT returns extended lattice with reflecting boundary
% conditions
latNS = [lat(1, :); lat; lat(end, :)];
extLat = [latNS(:, 1) latNS latNS(:, end) ];