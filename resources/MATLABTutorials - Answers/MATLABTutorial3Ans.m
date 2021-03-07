% MATLAB Tutorial 3 Answers
% MATLABTutorial3Ans.m

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

%% QRQ 2 a
br = zeros(2, 4)

%% QRQ 2 b
br(:, 1) = [1; 1]
% or
br(:,1) = 1

%% QRQ 2 c
br(1, 3) = 5

%% QRQ 2 d
ar

%% QRQ 2 e
ar + br

%% QRQ 2 f
ar .* br

%% QRQ 2 g
sqr = @(x) x .* x;

%% QRQ 2 h
sqr(ar)

%% QRQ 2 i
sum(sum(sqr(ar)))

%% QRQ 3
xLst = 1:9
gLst = 3 * sqrt(xLst)
pairsLst = [xLst; gLst]'

%% QRQ 4 a
x = 0.1:0.1:6;
plot(x, log(x .* x))
xlabel('x')
ylabel('y')

%% QRQ 4 b
axis([0 6 -2 4])

%% QRQ 4 c
axis equal

%% QRQ 5
clear('f');
f = @(x) x .* x;
clear('g');
g = @(x) f(x) + 1;
x = -3:0.1:3;
plot(x, f(x), 'k', x, g(x), 'k', x, 3*x + 2, 'g')

%% QRQ 6
plot(x, f(x), '-k', x, g(x), '.k', x, 3*x + 2, '-.k')

%% QRQ 7
plot(x, f(x), 'k', 'LineWidth', 1)
hold on
plot(x, g(x), 'k', 'LineWidth', 2)
plot(x, 3*x + 2, 'k', 'LineWidth', 4)
hold off

%% QRQ 8 a
xLst = [0.4 0.6 0.8 1.0];
yLst = [0.16 0.23 0.55 1.0];
plot(xLst, yLst, 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'g')
xlabel('x')
ylabel('y')

%% QRQ 8 b
curveFit = polyfit(xLst, yLst, 1)

%% QRQ 8 c
hold on
x = 0.4:0.02:1.0;
polyValues = polyval(curveFit, x);
plot(x, polyValues)

%% QRQ 8 d
curveFit2 = polyfit(xLst, yLst, 2)

%% QRQ 8 e
polyValues2 = polyval(curveFit2, x);
plot(x, polyValues2)

%% QRQ 8 f
hold off

%% QRQ 9
syms x y u v
subs(u + 7*v, {u, v}, {2.^x, log(y)})

% or
syms x y u v
s1 = subs(u + 7*v, u, 2.^x)
subs(s1, v, log(y))

%% QRQ 10
lst = load('BoxBODEM.dat')

%% QRQ 11 a
x = 0.01:0.1:4;
plot(x, exp(x), x, log(x))
xlabel('x')
ylabel('y')

%% QRQ 11 b
log10(7)

