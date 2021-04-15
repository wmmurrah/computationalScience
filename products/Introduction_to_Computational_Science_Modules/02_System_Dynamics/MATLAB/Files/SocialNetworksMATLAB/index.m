function [ indexNum ] = index( loc, locationIDLst )
%LOCATIONINDEX returns index of location in locationIDLst
%   Function returns index where loc occurs in list locationIDLst

indexNum = find(locationIDLst == loc);

end

