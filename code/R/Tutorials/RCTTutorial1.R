# R Computational Toolbox Tutorial 1
# File:  RCTTutorial1.R

# Introduction to Computational Science:
# Modeling and Simulation for the Sciences, 2nd Edition
# Angela B. Shiflet and George W. Shiflet
# Wofford College
# © 2014 by Princeton University Press

# R materials by Stephen Davies, University of Mary Washington
# stephen@umw.edu

# Getting Started

# Quick Review Question 1	Evaluate 100-factorial.

# Additional Features

# Quick Review Question 2	After pasting the answer to Quick Review
# Question 1, above, type your name and the date on a comment line 
# below this one.

# Quick Review Question 3	Add the fractions (not decimal numbers)
# one-half and three-fourths.


# Quick Review Question 4	log10(x) is the common logarithm of x, or
# logarithm to the base 10.  Evaluate the common logarithm of 23.4.


# Quick Review Question 5	log(x) is the natural logarithm of x, usually
# written as ln(x) in mathematical notation.  Evaluate the sine of the
# natural logarithm of 23.4.


# Quick Review Question 6	e^x is exp(x) in R.  Evaluate the number
# e^2.


# Variables and Assignments

# Quick Review Question 7	
# a.	Assign 4.8 to the variable time.

# b.	Type time and execute.  

# c.	Type time + 3 and execute.

# d.	Type time and execute.  Note that execution of Part c did not
# change the value of time.

# e.	Type time = time + 3 and execute.  Note that the result of Part c
# is returned.

# f.    Type time at the console and execute. Note that the variable's
# value has now been updated as desired.

# g.	Evaluate time^3. 



# Quick Review Question 8   Write a statement to assign 34 to variable time
# and then add 0.5 to time, changing its value.



# Quick Review Question 9	Use the c() function to create vector variables
# for each of the following:
# a.    A vector called ages with values 19, 21, 21, and 20.

# b.    A vector called names with values "Larry," "Curly," and "Moe."
# (Note: this should be a vector of three values, the first of which is
# "Larry” and the last of which is "Moe." It should *not* be a vector of
# just one value, whose value is "Larry, Curly, Moe".)




# Quick Review Question 10	Use the seq function to create vector variables
# for each of the following:
# a.    A vector called itemNumbers with all the whole numbers between (and
# including) 10000 and 10005.


# b.    A vector called pipeFittings with all the even numbers between (and
# including) 32 and 48.


# c.    A vector called timeChecks that contains numbers from 0 to 4, in
# increments of .25.


# d.    Now use the colon notation to recreate the itemNumbers vector (from
# step a) without the use of the seq() function.



# User-defined Functions

# Quick Review Question 11	Define a function quick(x) = 3sin(x - 1) + 2.
# Evaluate the function at 5.  



# Online Documentation

# Quick Review Question 12  

# As a COMMENT line, below, paste the code to access the help page for the
# built-in function "log10".



# Quick Review Question 13  

# Use the help system to search for the word "deviation" and see if
# you can discover the name of the function to perform a standard
# deviation. Paste the name of that function on the line below, as a
# comment.



# Displaying

# Quick Review Question 14	Write a statement to assign 3 to t.  Then,
# employ cat to display "Velocity is", the result of the computation
# -9.8 * t, and "m/sec." Output for the cat command should be as follows:
# Velocity is -29.4 m/sec.


# Looping

# Quick Review Question 15	Write a segment to assign 1 to a variable d. In
# a loop that executes 10 times, change the value of d to be double what it
# was before the previous iteration.  After the loop, type cat(d,"\n") so
# that R displays d's final value.  Before executing the loop, determine
# the final value so you can check your work.



# Quick Review Question 16	For this question, complete another version of
# the example that displays distance and time.  In this version, do not
# initialize dist.  Employ a loop with an index i that takes on integer
# values from 1 through 7.  Within the loop, the value of dist is computed
# as 2.25i.  
# Uncomment (remove the leading "#" character) the following code. Then, 
# after replacing each xxxxxxxxxx with the proper code, execute, and compare
# the results with the similar segment above.

# for xxxxxxxxxx
#    dist = xxxxxxxxxx						
#    t =  (24.5 - sqrt(600.25 - 19.6 * dist))/9.8;
#    cat("For distance ",dist,", time = ", round(t,2), " seconds.\n",sep="");
# xxxxxxxxxx



# Quick Review Question 17
# a.	Define the function qrq17(x) = ln(3x + 2).  Recall that log is the
# R function for the natural logarithm.


# b.	Write a loop that prints the value of k and qrq17(k) for k taking
# on integer values from 1 through 8.


# Plotting

# Quick Review Question 18	Graph e^sin(x) from -3 to 3 in .1 increments.


# Quick Review Question 19	Adjust the answer to the previous Quick Review
# Question to label the x and y axes.


# Differentiation

# Quick Review Question 20	Give R code to do the following:
# a. Create a function f = 2.9 sin(0.03x).

# b. Create an expression fexp = 2.9 sin(0.03x) so that it can be
# differentiated.

# c. Differentiate the expression using the D function (don't forget the
# second argument.)  Assign that differentiated expression to a variable df.

# d. Create a vector called x that contains values from -200 to 200 by twos.

# e. Plot the function f vs the x vector. Use parameters pch and col to draw
# the plot points with red X's.

# f. Add to the plot the derivative df vs the x vector. Use parameters pch
# and col to draw the plot points with purple O's. (Don't forget you'll need to use the eval function.)


# Integration

# Quick Review Question 21	Compute the definite integral of sin^2(x) from
# 0 to 2pi.



# You're done with this tutorial! Save this RTutorial1.R file and send it
# to your instructor.
