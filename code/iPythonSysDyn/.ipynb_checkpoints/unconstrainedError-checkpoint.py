# unconstrainedError.py# Function to display simulation of unconstrained growth# along with exact value and relative error percentimport math # Makes the math library available#from graphics import *WIN_WIDTH  = 500WIN_HEIGHT = 300# Function to run a simulation of unconstrained growth,# to display a table of time, population, actual error, and relative error;# and to return maximum time, maximum actual population, and list# of points with time, simulation population, and actual populationdef unconstrainedError(growthRate = 0.10, P = 100, DT = 1, simLength = 100):    initP = P    numIterations = int(simLength/DT) + 1    print ("         t   Population   Actual Population  Relative Error Percent")    t = 0    growth = growthRate * P    timeLst = [t]    PLst = [P]    actualLst = [initP]#    pts = [[t, P, initP]]    tLst = [t]    yLst = [initP]    print ('%10.2f\t%12.2f\t%12.2f\t%12.2f' % (t, P, initP, 0))    for i in range(1, numIterations):        t = i * DT        P = P + growth * DT        actualP = initP * math.exp(growthRate * t)        relativeErrorPercent = abs(P - actualP)*100/actualP        growth = growthRate * P        timeLst.append(t)        PLst.append(P)        actualLst.append(actualP)#        pts.append([t, P, actualP])        tLst.append(t)        yLst.append(actualP)        print ('%10.2f\t%12.2f\t%12.2f\t%12.2f' % (t, P, actualP, relativeErrorPercent))    return int(max(tLst) + 0.5), int(max(yLst) + 0.5), timeLst, PLst, actualLst#    return int(max(tLst) + 0.5), int(max(yLst) + 0.5), pts    # Function to plot points pts with horizontal axis going from# 0 to maxt and vertical axis going from 0 to maxy# # def plotGraph(maxt, maxy, pts):#     win = GraphWin("Comparison of Simulated and Actual", WIN_WIDTH, WIN_HEIGHT)#     win.setBackground("white")#     win.setCoords(-0.15 * maxt, -0.1 * maxy, 1.1 * maxt, 1.15 * maxy)#     plotArea = Rectangle(Point(0, 0), Point(maxt, maxy))#     plotArea.draw(win)#     for i in range(0, maxt + 1, 25):#         Text(Point(i, -0.05 * maxy), i).draw(win)# #     Text(Point(-0.08 * maxt, maxy/2), maxy/2).draw(win)#     Text(Point(-0.08 * maxt, maxy), maxy).draw(win)#     Text(Point(0, 1.08 * maxy), "population").draw(win)#     #     for pt in pts:#         win.plot(pt[0], pt[1], "red")#         win.plot(pt[0], pt[2], "blue")#main()