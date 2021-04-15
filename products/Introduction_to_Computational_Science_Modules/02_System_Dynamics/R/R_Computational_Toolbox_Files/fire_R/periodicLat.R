periodicLat = function(lat) {
# PERIODICLAT returns extended lattice
    extendRows = rbind(lat[nrow(lat),],lat,lat[1,])
    extlat = cbind(extendRows[,ncol(extendRows)],extendRows,extendRows[,1])
    return(extlat)
}
