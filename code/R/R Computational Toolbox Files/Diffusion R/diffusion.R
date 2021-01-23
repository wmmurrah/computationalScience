# DIFFUSION new value at cell due to diffusion
diffusion <- function(diffusionRate, site, N, NE, E, SE, S, SW, W, NW){
return ((1 - 8*diffusionRate) * site + diffusionRate*(N+NE+E+SE+S+SW+W+NW))
}
