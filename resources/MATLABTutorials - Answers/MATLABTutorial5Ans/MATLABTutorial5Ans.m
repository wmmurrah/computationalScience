% MATLAB Tutorial 5 Answers
% File:  MATLABTutorial5Ans.m

%% QRQ 1 a
lst = rand(1, 100)
max(lst)
min(lst)

%% QRQ 1 b
z = zeros(1, randi(20))
length(z)

%% QRQ 2
xLst = rand(1, 10);
yLst = rand(1, 10);
for n = 1:10
    plot(xLst(n), yLst(n), 'ob', 'MarkerFaceColor', 'b')
    hold on;
    axis([0 1 0 1])
    M(n) = getframe;
end
hold off;
movie(M, 1)

%% or

xLst = rand(1, 10);
yLst = rand(1, 10);
for n = 1:10
	plot(xLst(1:n), yLst(1:n), 'ob', 'MarkerFaceColor', 'b')
	axis([0 1 0 1])
	M(n) = getframe;
end
movie(M, 1)

%%
%% QRQ 3
pause on
clear('i', 'f', 't');
f = @(t, i)(1000*20)./((1000 - 20).*exp(-(1+0.2*i).*t) + 20);
t = 0:0.1:3;
for i = 1:10
   plot(t, f(t, i));
   axis([0 3 0 1000]);
   pause(0.5);
   M(i) = getframe;
end
%%
movie(M, 1, 5)
%%
%% QRQ 4
% a See rectCircumference.m
% b 
% Line 1:  The function return value 'circumference' might be unset.
% d
rectCircumference(3, 4.2)
%%
%% QRQ 5
% a See randIntRange.m
% b
for i = 1:10
    randIntRange(5, 9)
end
%%
%% QRQ 6
% a See squareStats.m
% b
[a c] = squareStats(3)
%%
%% QRQ 7
% Change values for x and y to test various situations
x = 5;
y = 5;
if (x + 2 > 3) || (y < x)
    y = y + 1
else
    x = x - 1
end    
%%
%% QRQ 8 a
x = 5;
v = [4 5 8 3 2]
if ismember(x, v)
    disp('Is a member')
else    
    disp('Is not a member')
end

%% QRQ 8 b
ismember([1 6], [1 2; 1 3; 5 6], 'rows')
%%
% Before QRQ 9
counter = 0;
ra = rand
while ra < 0.7
    counter = counter + 1;
    ra = rand
end
counter
%%
%% QRQ 9
x = 0;
i = 1;
while (-5 <= x) && (x <= 5)
	plot(x, 0, 'or', 'MarkerFaceColor', 'r', 'MarkerSize',18);
	axis([-6 6 -1 1]);
    M(i) = getframe;
    i = i + 1;
	x = x + randi(3) - 2;
end
movie(M, 1)