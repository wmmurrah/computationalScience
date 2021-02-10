% MATLAB Tutorial 2 Answers
% MATLABTutorial2Ans.m

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

%% QRQ 4
yLst = [6, 2, 12];
plot(xLst, yLst, 'o') 
xlabel('x')
ylabel('y')

%% QRQ 5
plot(xLst, yLst, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'k')

%% QRQ 6
plot(xLst, yLst, '-o', 'MarkerSize', 10, 'MarkerFaceColor', 'b')
xlabel('x')
ylabel('y')

%% QRQ 7

xValues = zeros(1, 30);
yValues = zeros(1, 30);
y = 1;
for i = 1:30 
    x = 0.25 * (i - 1); 
    xValues(1, i) = x;
    y = 1.2 * y;
    yValues(1, i) = y;
end
plot(xValues, yValues, '-o', 'MarkerSize', 10, 'MarkerFaceColor', 'b')
xlabel('x')
ylabel('y')
