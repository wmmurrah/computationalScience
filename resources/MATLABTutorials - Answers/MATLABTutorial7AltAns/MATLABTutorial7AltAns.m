% Alternative MATLAB Tutorial 7 Answers
% MATLABTutorial7AltAns.m

%% 
%%% From Tutorial 1

%% QRQ 9a
time = 4.8

%% QRQ 9b
time

%% QRQ 9c
time + 3

%% QRQ 9d
time

%% QRQ 9e
ans

%% QRQ 9f
ans^3

%% QRQ 11
time = 34
time = time + 0.5

%% QRQ 12
time = 34;
time = time + 0.5

%% QRQ 13
clear('f')
f = @(x) 3*sin(x - 1) + 2;
f(5)

%% QRQ 15a
help p

%% QRQ 15b
% Get help from Documentation under Help or type the following:
help exp

%% QRQ 16
t = 3;
disp(['Velocity is ', num2str(-9.8 * t), ' m/sec'])

%% QRQ 17
d = 1;

for i = 1:10 
  d = 2 * d; 
end

d

%% QRQ 18
d = 1;

for i = 1:10 
  d = 2 * d; 
  disp(['The new distance is ',  ...
         num2str(d), '.']);
end

%% QRQ 19
for i = 1:7
   dist = 2.25 * i;						
   t =  (24.5 - sqrt(600.25 - 19.6 * dist))/9.8;
   disp(['For distance = ', num2str(dist), ...
       ' time = ', num2str(t), ' seconds.']);
end

%% QRQ 20b
qrq20 = @(x) log(3*x + 2);

%% QRQ 20c
for k = 1:8
   disp(['qrq20(', num2str(k), ') = ', num2str(qrq20(k))]);
end

%% 
%%% From Tutorial 2
%%% 
%% QRQ 1
xLst = [-3, 5, 1]

%% QRQ 2
for i = 1:3
    disp(xLst(i))
end

%% QRQ 3 a
ptLst = [ -3 6; 5 2; 1 12]

%% QRQ 3 b
ptLst(3, :)

%% QRQ 3 c
ptLst(2, 1)

%% QRQ 3 d
ptLst(1, 2)

%% QRQ 3 e
ptLst(1, :)

%% QRQ 3 f
ptLst(:, 2)

%% 
%%% From Tutorial 3
%%% 
%% QRQ 1 a
ar = zeros(2, 4)

%% QRQ 1 b
ar(1, :) = [1, 3, 5, 7]

%% QRQ 1 c
3 * ar

%% QRQ 1 d
sqrt(ar)

%% QRQ 1 e
ar = ar + 2

%% QRQ 3
ptLstTrans = ptLst'

%% 
%%% From Tutorial 4
%%% 
%% QRQ 1
mat = rand(3)
%% 
%%% From Tutorial 5
%%% 
%% QRQ 4
% a See rectCircumference.m
% b 
% Line 1:  The function return value 'circumference' might be unset.
% d
rectCircumference(3, 4.2)

%% QRQ 6
% a See squareStats.m
% b
[a c] = squareStats(3)

%% QRQ 9
x = 0;
lst = [];
while (x <  5)
    lst = [lst x];
    x = x + rand();
end
lst

%% 
%%% From Tutorial 6
%%% 
%% QRQ 4 a
lst = zeros(randi([5,15]), randi(4))
size(lst, 1)

%% QRQ 4 b
size(lst, 2)
%% 
%%% From Tutorial 7
%%% 
%% QRQ 1 a
mA = zeros(4, 2);
for i = 1:4
    for j = 1:2
        mA(i, j) = i + j;
    end;
end;
mA

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

%% 
%%% For Module 13.5 from Tutorial 2
%%% 
%% QRQ 4
xLst = [-3, 5, 1];
yLst = [6, 2, 12];
plot(xLst, yLst, 'o') 
xlabel('x')
ylabel('y')

%% 
%%% For Module 13.5 from Tutorial 3
%%% 
%% QRQ 2 i
ar  = [1 3 5 7; -1 4 8 -2];
sum(sum(sqr(ar)))

%% 
%%% For Module 13.5 from Tutorial 4
%%% 
%% QRQ 6
r = rand
if r < 0.3
    1
else
    0
end    

%% QRQ 8
r = rand
if r < 0.2
    disp('Low')
elseif r < 0.5
    disp('Medium low')
elseif r < 0.8
    disp('Medium high')
else
    disp('High')
end

%% QRQ 10
lst = randi([0, 5], 1, 20)
sum(lst == 3)

%% QRQ 11
ints = randi([7, 30], 1, 50);
mean(ints)

%% QRQ 12
sinTbl = sin(pi * rand(1, 1000));
hist(sinTbl)

%%
%%% For Module 13.5 from Tutorial 5
%%% 
%% QRQ 1 a
lst = rand(1, 100)
max(lst)

%% QRQ 1 b
z = zeros(1, randi(20))
length(z)

%% 
%%% For Module 13.5 from Tutorial 7
%%% 
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
