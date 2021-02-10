function rnd = randIntRange(lower, upper)
% RANDINTRANGE Function to return a random integer
%    randIntRange(lower, upper) returns an integer between
%    lower and upper - 1, inclusively.
rnd = randi(upper - lower) + lower - 1;
% or rnd = randi([lower, upper - 1]);
end