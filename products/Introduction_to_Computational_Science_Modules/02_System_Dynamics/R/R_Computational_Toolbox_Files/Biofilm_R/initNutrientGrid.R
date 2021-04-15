initNutrientGrid<-function( m,n ){
# INITNUTRIENTGRID Function to return an initialized Nutrient Grid
#        initNutrientGrid( m,n ) returns an m-by-n matrix with each element
#        having the value MAXNUTRIENT
	utils::globalVariables(c(" MAXNUTRIENT"))
	NutrientGrid = matrix(rep(0,n*m),nrow=m)+ MAXNUTRIENT;
	return(NutrientGrid)
}
