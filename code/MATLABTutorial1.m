% MATLAB Tutorial 1
% File:  MATLABTutorial1.m

% Getting Started

%% Quick Review Question 1	Evaluate 100-factorial.
factorial(100)
% Additional Features

%% Quick Review Question 2	Have the MATLAB Desktop contain only the
% Command Window, and clear this window.  Type comment lines with your name
% and "Tutorial 1."  

% William Murrah
% Tutorial 1

%% Quick Review Question 3	
% a.	Preface this Quick Review Question with a comment that has "QRQ" and 
% the question number, such as follows:
% QRQ 3 

%% b.	Press the up arrow to recall the command to evaluate 100!.  Select
% 100, type 38, and execute the revised command, which evaluates 38!.
factorial(38)


%% c.	Recall the command from Part b, but do not execute it.  With one
% keystroke, delete the command.  In a comment, indicate the key you
% pressed to remove the command.

% Esc

% Script M-Files

%% Quick Review Question 4	
% a.	Open the file MATLABTutorial1.m, which contains the quick review
% questions for this tutorial.  


%% b.	From the Command Window, copy your answers from Quick Review
% Questions 1, 2, and 3b into the appropriate places.


%% c.	Execute the file MATLABTutorial1.m.  In a comment, indicate the
% shortcut to execute the entire file.

% Esc

%% d.	Save your new MATLAB to your disk.  Record all your answers to
% the following Quick Review Questions in MATLABTutorial1.m.  


% Numbers and Arithmetic Operations

%% Quick Review Question 5	Have a comment with "%% QRQ 5."  Add the fractions
% (not decimal numbers) one-half and three-fourths. MATLAB returns a
% decimal expansion.

%% QRQ 5

1/2 + 3/4 

%% Quick Review Question 6	log10(x) is the common logarithm of x, or
% logarithm to the base 10.  Evaluate the common logarithm of 23.4,
% recording your answer in MATLABTutorial1.m.

log10(23.4)

%% Quick Review Question 7	log(x) is the natural logarithm of x, usually
% written as ln(x) in mathematical notation.  Evaluate the sine of the
% natural logarithm of 23.4.

log(23.4)

%% Quick Review Question 8	e^x is exp(x) in MATLAB.  Evaluate the number
% e^2.

exp(2)

% Variables and Assignments

%% Quick Review Question 9	
% a.	Assign 4.8 to the variable time and execute the statement.  


%% b.	Type time and execute.  


%% c.	Type time + 3 and execute.


%% d.	Type time and execute.  Note that execution of Part c did not
% change the value of time.


%% e.	Type ans and execute.  Note that the result of Part c is returned.


%% f.	Evaluate ans^3. 


%% Quick Review Question 10
% a.	Type vel and execute.


%% b.	Make vel a symbolic variable.


%% c.	Type vel and execute.


%% d.	Type an expression for (7 + vel / 3)^2 and execute.


%% Quick Review Question 11	Write a segment to assign 34 to variable time
% and then to add 0.5 to time, changing its value.


%% Quick Review Question 12	Repeat the previous question suppressing the
% output from the initial assignment.


% User-defined Functions

%% Quick Review Question 13	Define a function f(x) = 3sin(x - 1) + 2.
% Evaluate the function at 5.  


%% Quick Review Question 14	
% a.	Clear any possible values for p and t.  


%% b.	Define the population function p(t) = 100e^(0.1t). 


%% c.	Evaluate p at t = 12.  


% Online Documentation

%% Quick Review Question 15  

% a.    By typing a command, obtain help on the function exp.

%% b.    List two ways to obtain help on the function exp from the Help
% menu.


% Displaying

%% Quick Review Question 16	Write a statement to assign 3 to t.  Then,
% employ disp and num2str to display "Velocity is", the result of the
% computation -9.8 * t, and "m/sec."  For proper spacing, be sure to type
% blanks in the string constants after "is" and before "m/sec".  Output for
% the disp command should be as follows:
% Velocity is -29.4 m/sec.


% Looping

%% Quick Review Question 17	Write a segment to assign 1 to a variable d
% without displaying 1.  In a loop that executes 10 times, change the value
% of d to be double what it was before the previous iteration.  After the
% loop, type d so that MATLAB displays d's final value.  Before executing
% the loop, determine the final value so you can check your work.


%% Quick Review Question 18	This question is a variation of Quick Review
% Question 17.  Write a segment to assign 1 to a variable d without displaying 1.  
% In a loop that executes 10 times, change the value of d to be double what it 
% was before the previous iteration and then print the value of d in a long sentence.  
% Use a continuation symbol to break the long disp command; be sure to have the 
% continuation symbol (?) at the end of the line, not in single quotation marks, and 
% after a comma.  The output appears on 10 lines.


%% Quick Review Question 19	For this question, complete another version of
% the segment above that displays distance and time.  In this version, do
% not initialize dist.  Employ a loop with an index i that takes on integer
% values from 1 through 7.  Within the loop, the value of dist is computed
% as 2.25i.  After replacing each xxxxxxxxxx with the proper code, execute,
% and compare the results with the similar segment above.

% for xxxxxxxxxx
%    dist = xxxxxxxxxx						
%    t =  (24.5 - sqrt(600.25 - 19.6 * dist))/9.8;
%    disp(['For distance = ', num2str(dist), ...
%        ' time = ', num2str(t), ' seconds.']);
% xxxxxxxxxx


%% Quick Review Question 20
% a.	Clear possible values for the symbols qrq20 and x.


%% b.	Define the function qrq20(x) = ln(3x + 2).  Recall that log is the
% MATLAB function for the natural logarithm.


%% c.	Write a loop that prints the value of k and qrq20(k) for k taking
% on integer values from 1 through 8.


% Plotting

%% Quick Review Question 21	Graph e^sin(x) from -3 to 3. 


%% Quick Review Question 22	Adjust the answer to the previous Quick Review
% Question to label the x and y axes.  


%% Quick Review Question 23 	Adjust the answer to the previous Quick Review
% Question to plot e^sin(x) and sin(x) on the same graph.


% Differentiation

%% Quick Review Question 24	Give MATLAB code to do the following:
% a.	Make x a symbol.


%% b.	Define y = 2.9 sin(0.03x).


%% c.	Evaluate the derivative of y with respect to x.


%% d.	Evaluate the derivative of y at 35.


% Solving Differential Equations

%% Quick Review Question 25	Write a MATLAB command to solve the
% differential equation P'(t) = 0.1P(t) with initial condition P(0) = 100.
% The module on "Unconstrained Growth" uses this differential equation.


% Integration

%% Quick Review Question 26	
% a.	Designate that x is a symbol.


%% b.	Obtain the indefinite integral of (sin(x))^2.


%% c.	Obtain the indefinite integral of (sin(x))^2 from 0 to 2?.
