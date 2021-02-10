diffusionSim = function(m,n,diffusionRate,hostSites,coldSites,t) {
#Declare global variables hot,cold and ambient.
# Initialize grid

bar = initBar(m,n,hotSites,coldSites)
bar
# Perform simulation

grids<-array(0, dim=c(m,n,t+1))
grids[,,1]<-bar

for(i in 2:(t+1)) {

#     Extend matrix
	barExtended = reflectingLat(bar)
#     Apply spread of heat function to each grid point
	bar = applyDiffusionExtended(diffusionRate,barExtended)
#     reapply hot and cold spots
	bar = applyHotCold(bar,hotSites,coldSites)
#    save new Matrix
	grids[,,i]<-bar

	}
return(grids)
}
