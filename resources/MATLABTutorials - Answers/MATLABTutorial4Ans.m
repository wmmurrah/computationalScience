% MATLAB Tutorial 4 Answers
% File:  MATLABTutorial4Ans.m

%% QRQ 1 a
rand(3)

%% QRQ 1 b
10 * rand(1, 5)

%% QRQ 1 c
4 * rand(2, 4) + 8

%% QRQ 2 a
randi(6)

%% QRQ 2 b
randi([18,22])
% or
randi(5) + 17

%% QRQ 3 a
randi(100, 10)
or
randi(100, 10, 10)

%% QRQ 3 b
rand('seed', 5555)
randi(100, 10)

%% QRQ 4
rand('seed', sum(100*clock))
y1 = randi([4,20], 50)
or 
y1 = randi(17, 1, 50) + 3

%% QRQ 5
r = 10;
r = rem(7 * r, 11)

%% QRQ 6
r = rand
if r < 0.3
    1
else
    0
end    

%% QRQ 7:  We expect 1 about 30% of the time.
cond = rand
if cond < 0.3 1, else 0, end

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

%% QRQ 9
lst = rand(1, 20)
sum(lst < 0.4)
sum(lst >= 0.6)

%% QRQ 10
lst = randi([0, 5], 1, 20)
sum(lst == 3)

%% QRQ 11 a
normalNums = randn(1, 10000);

%% QRQ 11 b
mean(normalNums)

%% QRQ 11 c
std(normalNums)

%% QRQ 11 d:  Yes

%%% QRQ 12 a
sinTbl = sin(pi * rand(1, 1000));

%% QRQ 12 b
hist(sinTbl)

%% QRQ 12 c
hist(sinTbl, 10)

%% QRQ 12 d:  0.9 to 1

%% QRQ 12 e:  About 280 for one execution - This answer will vary
