unconstrainedGrowth <- function(initial_value, 
                                delta_t, 
                                growth_rate, 
                                simulation_length) {
  num_iterations = simulation_length/delta_t
  t = seq(0, simulation_length, delta_t)
  pop = rep(NA, length(t))
  pop[1] <- initial_value
  growth = rep(NA, length(t))
  growth[1] <- pop[1]*growth_rate
  for(i in 2:length(t)){
    growth[i] <- growth_rate*pop[i-1]
    pop[i] <- pop[i-1] + growth[i]*delta_t
  }
  data.frame(t_hours = t, growth = growth, population = pop)
}
