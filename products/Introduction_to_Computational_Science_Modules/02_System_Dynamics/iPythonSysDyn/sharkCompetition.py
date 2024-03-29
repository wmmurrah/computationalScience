# sharkCompetition.py
# Program to run simulation of species competition between
# white tip sharks (WTS) and black tip sharks (BTS)

def sharkCompetition(DT = 0.001, simLength = 5):
    numIterations = int(simLength/DT) + 1
    t = 0

    WTS_population = 20
    BTS_population = 15

    WTS_birth_fraction = 1
    WTS_death_proportionality_constant = 0.27
    WTS_births = WTS_population * WTS_birth_fraction
    WTS_deaths = (WTS_death_proportionality_constant * BTS_population) * WTS_population

    BTS_birth_fraction = 1
    BTS_death_proportionality_constant = 0.2
    BTS_births = BTS_birth_fraction * BTS_population
    BTS_deaths = (BTS_death_proportionality_constant * WTS_population)*BTS_population

    tLst = [t]
    WTSLst = [WTS_population]
    BTSLst = [BTS_population]
    for i in range(1, numIterations):
        t = i * DT
        BTS_population = BTS_population + (BTS_births - BTS_deaths) * DT
        WTS_population = WTS_population + (WTS_births - WTS_deaths) * DT

        BTS_births = BTS_birth_fraction * BTS_population
        BTS_deaths = (BTS_death_proportionality_constant * WTS_population) * BTS_population

        WTS_births = WTS_population * WTS_birth_fraction
        WTS_deaths = (WTS_death_proportionality_constant * BTS_population) * WTS_population
        tLst.append(t)
        WTSLst.append(WTS_population)
        BTSLst.append(BTS_population)

    return tLst, WTSLst, BTSLst

