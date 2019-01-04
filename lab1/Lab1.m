% Sashankh Chengavalli Kumar - A0162363J 
diary on
close all
clear all

% Question 1.1
% Define matrices A, B, C
disp('Question 1.1')

A = [1 7 3; 2 4 1; 4 8 6]
B = [1 1 0.25; 2 4 1; 4 8 2]
C = [0; 0; 0]

% Question 1.2
% Singular Value Decomposition 

disp('Question 1.2')
[Ua, Sa, Va] = svd(A)
[Ub, Sb, Vb] = svd(B)

% Verifying that U and V are orthonormal matrices
disp('Calculating Ua * Ua_transpose we have')
Ua * Ua.'

disp('Calculating Va * Va_transpose we have')
Va * Va.'

disp('Calculating Ub * Ub_transpose we have')
Ub * Ub.'

disp('Calculating Vb * Vb_transpose we have')
Va * Va.'

disp('Clearly since all products are identity matrices, they are orthonormal matrices')
disp('Since dot product of vector and a perpendicular gives 0')

disp('Minimum singular value of A is the minimum from the diagonal elements, which gives 1.3523')
disp('A has three non-zero singular values, and hence its rank is 3')
disp('Minimum singular value of B is the minimum from the diagonal elements, which gives 0')
disp('Number of non-zero singular values is the rank of the matrix')

% Question 1.3
% Solving equation for Ax = C

disp('Question 1.3')
disp('The solution xa for Ax = C')
xa = Va*((Ua'*C)./diag(Sa))
disp('There is no non-zero solution for this case, as it is full rank')

% Solving equation for Bx = C
disp('The solution xb for Bx = C')

xb = Vb*((Ub'*C)./diag(Sb))
disp('Non-zero solution is any linear multiple of the third column of Vb, including')
Vb(:,3)

% Question 1.4
% Solving by linear least squares

disp('Question 1.4')
disp('Defining matrix F and G')
F = [10 -4 0; 2 3 2; 8 2 3; -2 7 2]
G = [1; 2; 3; 4]

disp('Rank of a matrix is the max number of linearly independent column vectors. Hence it can be at most 3, and not 4. In this case it is 3')
disp('Solving Fx = G')

% Linear least squares
disp('Linear least squares method manually')
inv(F.' * F) * F.' * G
disp('Verifying with MATLAB Method')
lsqlin(F, G, [], [])
disp('The solutions match')

disp('Solving for E')
E = [5 -4 0; 1 3 4; 4 3 6; -1 7 4];
solution = inv(E.' * E) * E.' * G
disp('E * solution gives:')
E * solution
disp('The values seem to be similar to the values of right hand side in equation')

% Question 2
disp('Question 2')

% Generate random matrix
low = 0;
high = 100;
A2 = (high - low).*rand(3,3) + low

disp('Eigenvalues are shown on the diagonals of D')
disp('Eigenvectors are shown as columns of V')
[V,D] = eig(A2)

for i = 1 : 3   
    disp("Pair " + i)
    disp("Eigenvalue: " + D(i,i))
    disp("Eigenvector: ")
    V(:,i)
    disp('Product of eigenvalue and eigenvector')
    product = A2 * V(:,i)
    lambda = product ./ V(:,i);
    disp('This shows that Ax = lambda x where lambda is same as eigenvalue')
    lambda(1,1)
end

diary off