applyHotCold = function(bar, hotSites, coldSites) {
# APPLYHOTCOLD return bar with hot and cold sites

utils::globalVariables(c("COLD", "HOT"))

newbar = bar

for(k in 1:length(hotSites[,1])){
	newbar[hotSites[k,1],hotSites[k,2]]<-HOT
	}
for(k in 1:length(coldSites[,1])) {
	newbar[coldSites[k,1],coldSites[k,2]]<-COLD
	}
return(newbar)
}
