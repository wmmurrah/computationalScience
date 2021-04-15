% PopsAndMatOps.m
% MATLAB file to accompany 
% "Living Links:  Applications of Matrix Operations to Population Studies"
% by Angela B. Shiflet and George W. Shiflet
% Wofford College, Spartanburg, South Carolina
w = [20.00, 6.57, 4.69, 3.08, 0.99, 0.02]

% or use blanks instead of commas as separators
b = [15.00 5.37 4.84 6.00 10.83 27.43]

% column vector uses semicolons to separate elements
b_col = [15.00; 5.37; 4.84; 6.00; 10.83; 27.43]

% 4th element of b
b(4)

% test if equal
all(b == b)
all(b == w)
all(b == [1.00, 5.37, 4.84, 6.00, 10.83, 27.43])

% addition of vectors
w + b

% Multiplication by a scalar
100 * w

% Dot Product
e = [280, 70];
b = [291, 9483];
dot(e, b)

% Size of a vector
length(e)

% Matrices 
% Use semicolons to separate rows
S = [20.00 15.00; 6.57 5.27; 4.69 4.84; 3.08 6.00; 0.99 10.83; 0.02 27.43]

% Scalar Multiplication 
100 * S

% Matrix Sums
S + S

% Matrix Multiplication
S * [20; 18]

A = [20 0.25 0.30; 18 0.00 0.20]

S * A

% Transpose - switch rows and columns
w
w'
S'