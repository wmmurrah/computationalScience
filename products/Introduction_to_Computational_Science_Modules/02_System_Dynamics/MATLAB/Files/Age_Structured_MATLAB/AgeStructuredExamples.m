%% Age Structured Model
% Suppose a certain bird has a maximum life span of three years.  
% During the first year, the animal does not breed.  
% On the average, a typical female of this hypothetical species lays ten 
% eggs during the second year but only eight during the third.  
% Suppose 15% of the young birds live to the second year of life, 
% while 50% of the birds from age 1-to-2 years live to their third year of 
% life, age 2-to-3 years.
% 
% Leslie matrix, L, and population distribution vector, x
% 
L = [0, 5, 4; 0.15, 0, 0; 0, 0.5, 0]
x = [3000; 440; 350]
% 
% Distribution at time t = 1
% 
x1 = L*x
% 
% Calculate the distribution at time t = 2
% 
x2 = L*x1
% 
% Calculate the distribution at time t = 2 as (L^2)x
% 
x2 = (L^2)*x
% 
% Calculate the distribution at time t = n as (L^n)x
% 
n = 20;
xn = (L^20)*x
% 
% Vector of percentages of animals in each category at time n = 20
% 
n = 20;
xn = (L^20)*x;
fractions = xn/sum(xn)
% 
% Results expressed as percentages
% 
100*fractions
% 
% Projected population growth rate, lambda, calculated as an eigenvalue of L
% We use the dominant eigenvalue value, 1.0216.
% 
[V, D] = eig(L)
% 
% Estimate the projected population growth rate, lambda, 
% by calculating (L^(n+1)x)/(L^nx) for "large" n and using any of the 
% elements for the estimate
% 
n = 20;
((L^(n + 1))*x) ./ ((L^n)*x)
% 
% Calculate the projected population growth rate, lambda, 
% to within m = 4 decimal places
% 
xFirst = x;
xSecond = L*x;
ratio1 = xSecond./xFirst;
xThird = L*xSecond;
ratio2 = xThird./xSecond;
n = 0;
m = 4;
toWithin = 10^-m;
while(abs(ratio1(1) - ratio2(1)) > toWithin)
    xFirst = xSecond;
    xSecond = xThird;
    ratio1 = xSecond./xFirst;
    xThird = L*xSecond;
    ratio2 = xThird./xSecond;
    n = n + 1;
end;
n
ratio2(1)
% 
% Show first components of (L^(n+1)x)/(L^nx) for n = 14 and n = 15
% 
format long 
n = 14;
ratio = (L^(n+1)*x)./((L^n)*x);
ratio(1)
% 
n = 15;
ratio = (L^(n+1)*x)./((L^n)*x);
ratio(1)
% 
% Calculate category fractions to within m = 6 decimal places 
% 
xFirst = x;
totalFirst = sum(xFirst);
ratio1 = xFirst./totalFirst;
xSecond = L*x;
totalSecond = sum(xSecond);
ratio2 = xSecond./totalSecond;
n = 0;
m = 6;
toWithin = 10^-m;
while(any(abs(ratio1 - ratio2) > toWithin))
    ratio1 = ratio2;
    xSecond = L*xSecond;
    totalSecond = sum(xSecond);
    ratio2 = xSecond./totalSecond;
    n = n + 1;
end;
n
ratio2
%% 
% A lionfish goes through three stages: larvae (L, about 1 month), 
% juvenile (J, about 1 year), and adult (A).  With one-month being the 
% basic time step, the probability that a larva survives and grows to 
% the next stage is GL = 0.00003, while the probability that a juvenile 
% survives and remains a juvenile in a one-month period is PJ = 0.777.  
% In one month, GJ = 0.071 fraction of the juveniles mature to the 
% adult stage, while PA = 0.949 fraction of the adults survive.  Only 
% adults give birth, and their fecundity for female larvae per month 
% is RA = 35,315.  
% 
L = [0 0 35315; 0.00003 0.777 0; 0 0.071 0.949]
eig(L)
L = [0 0 35315; 0.00003 0.777 0; 0 0.071 0.66]
eig(L)
L = [0 0 35315; 0.00003 0.64491 0; 0 0.071 0.78767]
eig(L)
%
% Sensitivity Analysis
%
prob1to2 = 0.15;
prob2to3 = 0.5;
eigOrig = AgeStructured( prob1to2, prob2to3 )
for percent = [0.1, 0.2, -0.1, -0.2]
    newP = (1 + percent) * prob1to2;
    eigNew = AgeStructured(newP, prob2to3 );
    changeInEig = eigNew - eigOrig;
    changeInP = percent * prob1to2;
    percent
    changeInEig / changeInP
end;

for percent = [0.1, 0.2, -0.1, -0.2]
    newP = (1 + percent) * prob2to3
    eigNew = AgeStructured( prob1to2, newP )
    changeInEig = eigNew - eigOrig
    changeInP = percent * prob2to3
    changeInEig / changeInP
end;
