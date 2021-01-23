function dominantEig = AgeStructured( prob1to2, prob2to3 )
%AGESTRUCTURED Dominant eigenvalue of age-structure matrix
%   AgeStructured( prob1to2, prob2to3 ) returns
%   the dominant eigenvalue of the 3-by-3 age structured matrix
%   [0 5 4; prob1to2 0 0; 0 prob2to3 0].
mat = [0 5 4; prob1to2 0 0; 0 prob2to3 0];
eigenvalues = eig(mat);
dominantEig = max(abs(eigenvalues));
end