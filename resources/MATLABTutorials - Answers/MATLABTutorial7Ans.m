% MATLAB Tutorial 7 Answers
% MATLABTutorial7Ans.m

%% QRQ 1 a
mA = zeros(4, 2);
for i = 1:4
    for j = 1:2
        mA(i, j) = i + j;
    end;
end;
mA
%% QRQ 1b
mO = ones(4, 2);
%% QRQ 1c
mA + mO
%% QRQ 1d
u = [2 7]
%% QRQ 1e
v = [5 3]
%% QRQ 1f
dot(u, v)
%% QRQ 1 g
mB = zeros(2, 3);
for i = 1:2
    for j = 1:3
        mB(i, j) = i - j;
    end;
end;
mB
%% QRQ 1 h
mA * mB
%% QRQ 2 a
mC = zeros(3, 3);
for i = 1:3
    for j = 1:3
        mC(i, j) = 2 * i + j;
    end;
end;
%% QRQ 2 b
mC ^ 5
%% QRQ 2 c
mC * mC * mC * mC * mC
%% QRQ 3 a
mD = [4 6; 3 1];
%% QRQ 3 b
eig(mD)
%% QRQ 3 c
[vLst, lLst] = eig(mD)
%% QRQ 3 d
v = vLst(:, 1)
lambda = lLst(1)
lambda * v
mD * v
%% QRQ 4 a
lst1 = zeros(1, 5);
for i = 1:5
    lst1(1) = randi([0, 2]);
end
lst1
%% QRQ 4 b
lst1 = unique(lst1)
%% QRQ 4 c
lst2 = zeros(1, 5);
for i = 1:5
    lst2(1) = randi([10, 12]);
end
lst2
lst3 = union(lst1, lst2)
%% QRQ 4 d
dup1 = zeros(5, 2);
for i = 1:5
    dup1(i, 1) = randi([0, 2]);
end
for i = 1:5
    dup1(i, 2) = randi([10, 12]);
end
dup1
sortrows(dup1, -1)
