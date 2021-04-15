# unconstrained.py

# Function to run a simulation of unconstrained growth and to
# return lists of times and populations

def unconstrained(growthRate = 0.10, P = 100, DT = 0.25, simLength = 40):
    numIterations = int(simLength/DT) + 1
    t = 0
    growth = growthRate * P
    timeLst = [t]
    populationLst = [P]
    for i in range(1, numIterations):
        t = i * DT
        P = P + growth * DT
        growth = growthRate * P
        timeLst.append(t)
        populationLst.append(P)
    return timeLst, populationLst
