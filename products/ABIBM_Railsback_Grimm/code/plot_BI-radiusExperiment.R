
library(ggplot2)
library(tidyr)

biexdat <- read.csv("data/business-investor-model-senseRange experiment-table.csv",
                    header = TRUE, skip = 6)
names(biexdat) <- c("num.runs", "sensing.radius", "step", "mean.wealth", 
                    "sd.wealth", "year")

biexdat <- transform(biexdat,
                     sensing.radius = factor(sensing.radius))

biexdat.long <- biexdat %>% gather(measure, value, mean.wealth:sd.wealth)

aggdat <- aggregate(value ~ sensing.radius + measure, biexdat.long, mean)



ggplot(aggdat, aes(x = sensing.radius, y = value, shape = measure)) + 
  geom_point()


yeardat <- aggregate(mean.wealth ~ sensing.radius + year, biexdat, mean)

ggplot(yeardat, aes(x = year, y = mean.wealth, color = sensing.radius)) + 
  geom_line()
