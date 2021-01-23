% MATLAB Function Tutorial
% File:  FunctionsTutorial.m

%%%
% Quick Review Question 1	
% a.    Execute the following MATLAB command, which plots the 
% above function, f(t) = 2t + 1,  from t = -3 to t = 3:
t = -3:0.1:3;
plot(t, 2*t + 1)

%% b.	By replacing xxxxxx with the appropriate equation, 
% complete the command below to graph f along with the equation 
% of the line with the same slope as f but with y-intercept 3.
% The graph of the new function will be in dashed and in a
% different color than that of f(t) = 2t + 1.
plot(t, 2*t + 1, t, xxxxxx, '--')

%% c.	Copy the command from Part b, and change the second 
% function to have a y-intercept of -3.

%% d.	Describe the effect that changing the y-intercept has on
%  the graph of the line.

%% e.	Copy the command from Part b, and change the second 
% function to have the same y-intercept as f but slope 3.

%% f.	Copy the command from Part b, and change the second 
% function to have the same y-intercept as f but slope -3.

%% g.	Describe the effect that changing the slope has on the 
% graph of the line.

%%%
% Quick Review Question 2	
% a.    Execute the following MATLAB command, which plots 
% the above function, s(t) = -4.9t^2 + 15t + 11,  from t = -1 to 
% t = 4:
% (NOTE that we use .^ for exponentiation of the sequence for t.)
t = -2:0.1:4;
plot(t, -4.9*t.^2 + 15*t + 11)

%% b.	Give the command to plot s(t) and another function with
% the same shape that crosses the y-axis at 2. Have the graph of
% the new function be dashed.

%% c.	Using calculus, determine the time t at which the ball
% reaches its highest point.  Verify your answer by referring to
% the graph.

%% d.	What effect does changing the sign of the coefficient of
% t^2 have on the graph?

%%%
% Quick Review Question 3	In this question, we consider various
% transformations on a function.  Use .^ for exponentiation of
% the sequence for t.
% a.	Plot t^2, t^2 + 3, and t^2 Ð 3 on the same graph, using
% dashing for the second curve and dotting for the third.

%% b.	Describe the effect of adding a positive number to a
% function.

%% c.	Describe the effect of subtracting a positive number
% from a function.

%% d.	Plot t^2, (t + 3)^2, and (t - 3)^2 on the same graph,
% using dashing for the second curve and dotting for the third. 

%% e.	Describe the effect of adding a positive number to the
% independent variable in a function.

%% f.	Describe the effect of subtracting a positive number
% from to the independent variable in a function.

%% g.	Plot t^2 and -t^2 on the same graph, using dashing for
% the second curve.

%% h.	Describe the effect of multiplying a function by -1.

%% i.	Plot t^2, 5 t^2, and 0.2 t^2 on the same graph, using
% dashing for the second curve and dotting for the third.

%% j.	Describe the effect of multiplying the function by
% number greater than 1.

%% k.	Describe the effect of multiplying the function by
% positive number less than 1.

%%%
% Quick Review Question 4	
% a.    Execute the following MATLAB command that plots
% the polynomial function p(t) = t^3 - 4t^2 - t + 4  from t = -2
% to t = 5 with .^ for exponentiation of the sequence for t:
t = -2:0.1:5;
plot(t, t.^3 - 4*t.^2 - t + 4)

%% b.	Give to what p(t) goes as t goes to infinity.

%% c.	Give to what p(t) goes as t goes to minus infinity.

%% d.	Plot p(t) and another function with each coefficient 
% having the opposite sign as in p(t).  Have the new function
% be dashed.

%% e.	Give to what the new function from Part d goes as t goes
% to infinity.

%% f.	Give to what the new function from Part d goes as t goes
% to minus infinity.

%%%
% Quick Review Question 5	Plot each of the following
% transformations of the square root function.  The square root
% function in MATLAB is sqrt.
% a.	Move the graph to the right 5 units.

%% b.	Move the graph up 3 units.

%% c.	Rotate the graph around the x-axis

%% d.	Double the height of each point.

%%%
% Quick Review Question 6	Complete the following questions 
% about exponential functions.  The exponential function with 
% base e in MATLAB is exp.
% a.	Define an exponential function u(t) with initial value
% 500 and continuous rate 12%.
t = 't';

%% b.	Plot this function.

%% c.	On the same graph, plot exponential functions with
% initial value 500 and continuous rates of 12%, 13%, and 14%. 
% Which rises the fastest?

%% d.	Express the function u(t) as an exponential function
% with base 4.

%%%
% Quick Review Question 7	
% a	Define an exponential function v(t) with initial value 5 and continuous
% rate -82%.

%% b.	Plot this function.

%% c.	Plot v(t) and v(t) + 7 on the same graph with the latter
% dashed.

%% d.	What effect does adding 7 have on the graph?

%% e.	As t goes to infinity, what does v(t) approach?

%% f.	As t goes to infinity, what does v(t) + 7 approach?

%% g.	Copy the answer to Part b.  In the copy, plot v(t)
% and -v(t).

%% h.	What effect does negation (multiplying by -1) have on
% the graph?

%% i.	Copy the answer to Part g.  In the copy, plot v(t) and
% 7 - v(t).

%% j.	As t goes to infinity, what does 7 - v(t) approach?

%% k.	Give the value of 7 - v(t) when t = 0.

%%%
% Quick Review Question 8	Complete this question, which
% considers a function that has an independent variable t as a
% factor and as an exponent.
% a.	Plot 12te^(-2t) from t = 0 to t = 5.

%% b.	Initially, with values of t close to 0, give the factor
% that has the most impact, t or exp(-2*t).

%% c.	As t gets larger, give the factor that has the most
% impact, t or exp(-2*t).

%%%
% NOTE:  
% NOTE:  
% NOTE:  
% Quick Review Question 9	In MATLAB, log(x) is the natural
% +logarithm, or logarithm to the base e, of x, which is ln(x)
% in mathematics; log10(x) is the common logarithm, or logarithm
% to the base 10, of x, which is log(x) in mathematics; and
% log2(x) is the logarithm to the base 2 of x.
% a.	Evaluate the logarithm to the base 2 of 8.

%% b.	Write y = log 7 as a corresponding equation involving an
% exponential function.

%% c.	Evaluate ln(e^5.3).

%% d.	Evaluate 10^log(6.1).

%%%
% Quick Review Question 10	When plotting several functions
% together, use a solid line for the first, dashed for the
% second, and dotted for the third.  
% a.	Plot the logistic function with initial population
% P0 = 20, carrying capacity M = 1000, and instantaneous rate of
% change of births r = 50% = 0.5 from t = 0 to t = 16 to obtain
% a graph as in Figure 2.3.1 of Module 2.3 on "Constrained
% Growth."

%% b.	On the same graph, plot three logistic functions that
% each have M = 1000 and r = 0.5 but P0 values of 20, 100, and
% 200.

%% c.	What effect does P0 have on a logistic graph?

%% d.	On the same graph, plot three logistic functions that
% each have M = 1000 and P0 = 20 but r values of 0.2, 0.5, and
% 0.8.

%% e.	What effect does r have on a logistic graph?

%% f.	On the same graph, plot three logistic functions that
% each have P0 = 20 and r = 0.5 but M values of 1000, 1300, and
% 2000.

%% g.	What effect does M have on a logistic graph?

%%%
% Quick Review Question 11  This question concerns the sine
% function.  In MATLAB, sin t is sin(t).	
% a.	Evaluate sin t where x = 0.6 and y = 0.8.

%% b.	Evaluate sin(¹/3) where the corresponding point on the
% unit circle is (1/2, sqrt(3)/2).

%% c.	Give the domain of the sine function.

%% d.	Give the range of the sine function.

%% e.	Give sine's period, or length of time before the
% function starts repeating.

%% f.	Is sin t positive or negative for values of t in the
% first quadrant?

%% g.	Is sin t positive or negative for values of t in the
% second quadrant?

%% h.	Is sin t positive or negative for values of t in the
% third quadrant?

%% i.	Is sin t positive or negative for values of t in the
% fourth quadrant?

%%%
% Quick Review Question 12	This question concerns the cosine
% function.  In MATLAB, cos t is cos(t).
% a.	Evaluate cos(0).

%% b.	Evaluate cos(¹/2).

%% c.	Evaluate cos(¹).

%% d.	Evaluate cos(3¹/2).

%% e.	Evaluate cos(¹/3) where the corresponding point on the
% unit circle is (1/2, sqrt(3)/2).

%% f.	Give the maximum value of cos t.

%% g.	Give the minimum value of cos t.

%% h.	Give the domain of the cosine function.

%% i.	Give the period of the cosine function.

%% j.	Is cos t positive or negative for values of t in the
% first quadrant?

%% k.	Is cos t positive or negative for values of t in the
% second quadrant?

%% l.	Is cos t positive or negative for values of t in the
% third quadrant?

%% m.	Is cos t positive or negative for values of t in the
% fourth quadrant?

%%%
% Quick Review Question 13	Plot each following pair of functions
% with the second function dashed:
% a.	sin t and 2 sin(7t)

%% b.	sin t and a function involving sine that has amplitude 5
% and period 6¹.

%% c.	sin t and a function involving sine that has minimum
% value Ð2 and maximum value 4.

%% d.	sin t and a function involving sine that has amplitude
% 4 and crosses the t-axis at each of the following values of
% t:  É, -¹/6, ¹/3, 5¹/6, É.

%% e.	cos t and a function involving cosine that has amplitude
% 3, period ¹, achieves its maximum value at t = ¹/5, and the
% maximum value is 2.

%% f.	sin(5t) and exp(-t) sin(5t).  The latter is a function
% of decaying oscillations.  The general form of such a function
% is A e^(-Ct) sin(Bt).

%%%
% Quick Review Question 14	This question concerns the tangent
% function. In MATLAB, tan t is tan(t).
% a.	Evaluate tan(¹/3) where the corresponding point on the
% unit circle is (1/2, sqrt(3)/2).

%% b.	Evaluate tan(0).

%% c.	Evaluate tan(¹).

%% d.	Evaluate tan(¹/2).

%% e.	As t approaches ¹/2 from values less than ¹/2, what does
% tan t approach?

%% f.	As t approaches ¹/2 from values greater than ¹/2, what
% does tan t approach?

%% g.	Evaluate tan(-¹/2).

%% h.	As t approaches -¹/2 from values greater than -¹/2, what
% does tan t approach?

%% i.	As t approaches -¹/2 from values less than -¹/2, what
% does tan t approach?

%% j.	Give the range of the tangent function.

%% k.	Give all the values between Ð2¹ and 2¹ for which tan t
% is not defined.

%% l.	Give an angle in the third quadrant that has the same
% value of tan t, where t is in the first quadrant.

%% m.	Give an angle in the fourth quadrant that has the same
% value of tan t, where t is in the second quadrant.

%% n.	Give the period of the tangent function.
