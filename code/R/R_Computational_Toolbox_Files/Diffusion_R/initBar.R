#Initialize the bar
initBar <-function(m,n,hotSites,coldSites){
utils::globalVariables(c("AMBIENT"))
bar <-AMBIENT*(matrix(c(rep(1,m*n)), nrow = m))
bar = applyHotCold(bar, hotSites,coldSites)
return(bar)}

