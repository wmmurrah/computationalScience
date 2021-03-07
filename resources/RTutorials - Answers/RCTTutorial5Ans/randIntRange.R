randIntRange = function(lower, upper) {
# RANDINTRANGE Function to return a random integer
#    randIntRange(lower, upper) returns an integer between
#    lower and upper - 1, inclusively.
   return(floor(runif(1, lower, upper + 1)))
}