#************************************************************************
# Title: plot-corridor-width.R
# Author: William Murrah
# Description: Plot corridor width for q = .1 to .9.
# Created: Sunday, 25 April 2021
# R version: R version 4.0.5 (2021-03-31)
# Project(working) directory: /Users/wmm0017/Projects/Learning/computationalScience
#************************************************************************

# Function to import csv files into one data frame with id variable.
stack_data <- function(datDir) {
  require(data.table)
  filenames <- list.files(dataDir)
  lst <- list()
  for(i in 1:length(filenames)) {
    lst[[i]] <- read.csv(file = paste0(datDir, filenames[i]), skip = 16, 
                       header = TRUE)
  }
  return(rbindlist(lst, idcol = "q"))
}

dat <- stack_data("data/corridor-width-data/")

dat$q <- factor(dat$q)
library(ggplot2)

ggplot(dat, aes(x = x, y = y, color = q)) + geom_line()
