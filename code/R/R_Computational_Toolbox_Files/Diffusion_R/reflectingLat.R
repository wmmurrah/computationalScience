reflectingLat = function(lat){
# REFLECTINGLAT returns extended lattice with reflecting boundary
# conditions
	latNS = rbind(lat[1,],lat,lat[nrow(lat),])
	extLat = cbind(latNS[,1], latNS, latNS[,ncol(latNS)])
	return (extLat)}

