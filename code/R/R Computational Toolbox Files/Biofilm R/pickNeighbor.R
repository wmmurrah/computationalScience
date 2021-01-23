pickNeighbor<-function(i, j, m, N, E, S, W){
#        PICKNEIGHBOR returns a randomly selected empty neighbor
#        pickNeighbor(i,j,m,N,E,S,W ) returns an empty neighbor of (i,j) or
#        (i,j) if none of the neighbors are empty
# 	m is the number of rows in un-extended matrix.

	lst= c(N, E, S, W);
	pos = which(lst == 0)
	newi= i - 1
	newj= j - 1
	if(length(pos) == 0){
	    a = newi
	    b = newj
	}else{
	    r = ceiling(runif(1,0,(length(pos))))
	    if( pos[r] == 1) { 
			if (newi > 1){
				a = newi - 1
				b = newj
			}else{
				a = m
				b = newj
			}            
	     }
	     if(pos[r] == 2){
			a = newi;
			b = newj + 1;
	      }			
	     if(pos[r] == 3){
			if (newi < m){
				a = newi + 1
				b = newj
			}else{
				a = 1
				b = newj
			}
		}
	     if(pos[r] == 4){
			a = newi
			b = newj - 1
		}
	}
	return(c(a,b))
}
