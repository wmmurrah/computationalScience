% Module 9.4
% File:  Distributions.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Statistical Distributions

% Generate 10000 uniformly distributed random numbers between 0.0 and 1.0 and generate histogram with 10 categories
tbl = rand(1,10000);
hist(tbl, 10)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normal Distributions

% A normal or Gaussian distribution, which statistics frequently employs, has the following probability density function, where mu is the mean and sigma is the standard deviation:
normalPDF = @(mu, sigma, x) exp(-(x - mu).^2/2/sigma^2)/sqrt(2*pi*sigma^2);

% Produce a plot of this function with mean 70 and standard deviation 5
x = 50:0.1:90;
plot(x, normalPDF(70, 5, x))

% One random number from normal distribution with mean 0 and standard deviation 1
r = randn

% Generate 1000 random numbers from normal distribution with mean 0 and standard deviation 1.  Employs r from above.  Display histogram.
tblNormal = randn(1, 1000);
hist(tblNormal, 13)

% Generate 1000 random numbers from normal distribution with 
% mean 3 and standard deviation 5.  
% To do so, multiply the output of randn by the standard 
% deviation, 5, and add the mean, 3.
% Display histogram.
tblNormal = 5 * randn(1, 1000) + 3;
hist(tblNormal, 11);
