globals
 [
   ; Model run parameters
   years-simulated
   num-investors

   ; Profit landscape parameters
   patch-mean-profit
   patch-min-risk
   patch-max-risk

   ; Investor parameters
   decision-time-horizon

   P-move-to-higher-profit-lower-risk
   P-move-to-higher-profit-higher-risk
   P-move-to-lower-profit-lower-risk
   P-move-to-lower-profit-higher-risk
  ]

patches-own
 [
  profit
  annual-risk
 ]

turtles-own
 [
  wealth
  current-utility
  old-wealth
  old-patch
  HiProfit-LowRisk-alts
  HiProfit-HiRisk-alts
  LowProfit-LowRisk-alts
  LowProfit-HiRisk-alts
 ]

to setup

  ca
  reset-ticks

 ; Initialize global variables
  set years-simulated    50

  set num-investors 25

  set patch-mean-profit    5000
  set patch-min-risk  0.01
  set patch-max-risk  0.1

  set decision-time-horizon 5

  set P-move-to-higher-profit-lower-risk  0.80
  set P-move-to-higher-profit-higher-risk 0.051
  set P-move-to-lower-profit-lower-risk   0.032
  set P-move-to-lower-profit-higher-risk  0.0

 ; Initialize patch profit and risk characteristics
  ask patches
    [
     ; Set the profitability
     set profit random-exponential patch-mean-profit

     ; Set the risk
     set annual-risk patch-min-risk + random-float (patch-max-risk - patch-min-risk)

     ; Color patches by profit: greener is richer
     set pcolor scale-color green profit 0 (3 * patch-mean-profit)

     ; Label patches by risk
     set plabel precision annual-risk 2
    ]

 ; Create the investors
 crt num-investors
  [
   move-to one-of patches with [not any? turtles-here]
   set wealth 0.0
   pen-down
  ]

 ; Open an output file for testing and analysis
 ; THIS WILL NOT WORK if you use BehaviorSpace running on more than one processor!
 ; First, delete it instead of appending to it
   if (file-exists? "TestOutput-Investors.csv") [carefully [file-delete "TestOutput-Investors.csv"] [print error-message]]
   file-open "TestOutput-Investors.csv"
      file-type "id,"
      file-type "tick,"
      file-type "wealth,"
      file-type "profit,"
      file-type "risk,"
      file-type "old-wealth,"
      file-type "old-profit,"
      file-type "old-risk,"
      file-type "any-HiProfit-LowRisk,"
      file-type "any-HiProfit-HiRisk,"
      file-type "any-LoProfit-LowRisk,"
      file-type "any-LoProfit-HiRisk,"
     file-print "utility"
   file-close

 ; Finally, write output for initial state of model
 ; output --  No, causes run-time error now.

end

to go

  tick

  if ticks > years-simulated [stop]

  ask turtles [reposition]

  ask turtles [do-accounting]

  output

end

to reposition

  ; First identify potential neighbor destination patches
  let potential-destinations neighbors with [not any? turtles-here]

  ; Then categorize alternatives by profit and risk
  set HiProfit-LowRisk-alts potential-destinations with [(profit > [profit] of myself) and (annual-risk < [annual-risk] of myself)]
  set HiProfit-HiRisk-alts potential-destinations with [(profit > [profit] of myself) and (annual-risk > [annual-risk] of myself)]
  set LowProfit-LowRisk-alts potential-destinations with [(profit < [profit] of myself) and (annual-risk < [annual-risk] of myself)]
  set LowProfit-HiRisk-alts potential-destinations with [(profit < [profit] of myself) and (annual-risk > [annual-risk] of myself)]

  ; Select destination using probabilities- which are global variables
  if any? HiProfit-LowRisk-alts
    [
      if random-bernoulli P-move-to-higher-profit-lower-risk
      [
        ; Now move there
        set old-patch patch-here
        move-to one-of HiProfit-LowRisk-alts
        stop  ; Turtles can only move once per tick!
      ]
    ]

  if any? HiProfit-HiRisk-alts
    [
      if random-bernoulli P-move-to-higher-profit-higher-risk
      [
        ; Now move there
        set old-patch patch-here
        move-to one-of HiProfit-HiRisk-alts
        stop  ; Turtles can only move once per tick!
      ]
    ]

  if any? LowProfit-LowRisk-alts
    [
      if random-bernoulli P-move-to-lower-profit-lower-risk
      [
        ; Now move there
        set old-patch patch-here
        move-to one-of LowProfit-LowRisk-alts
        stop  ; Turtles can only move once per tick!
      ]
    ]

  if any? LowProfit-HiRisk-alts
    [
      if random-bernoulli P-move-to-lower-profit-higher-risk
      [
        ; Now move there
        set old-patch patch-here
        move-to one-of LowProfit-HiRisk-alts
        stop  ; Turtles can only move once per tick!
      ]
    ]

  ; Now -- if we are here, then "stop" was not called so we did not move
  set old-patch patch-here

end

to do-accounting

  ; For test output, save old wealth
  set old-wealth wealth

  ; First, add this year's profits
  set wealth (wealth + profit)

  ; Now see if the investment failed
  if random-bernoulli annual-risk [set wealth 0]

  ; For output and analysis, calculate investor utility
  set current-utility utility-for self

end

to-report utility-for [a-turtle]
 ; Edit this to change how turtles evaluate alternative patches

 ; For the simple microeconomic utility function, first calc. expected
 ; wealth over the time horizon
 let turtles-wealth [wealth] of a-turtle
 let utility turtles-wealth + (profit * decision-time-horizon)

 ; Then factor in risk of failure over time horizon
 set utility utility * ((1 - annual-risk) ^ decision-time-horizon)

 report utility

end


to output

    set-current-plot "UtilityHistogram"
    histogram [current-utility] of turtles

    set-current-plot "Mean Investor Wealth"
    plot mean [wealth] of turtles

    set-current-plot "Mean Profit"
    plot mean [profit] of turtles

    set-current-plot "Mean Risk"
    plot mean [annual-risk] of turtles

    ; Write turtle states to output file
    file-open "TestOutput-Investors.csv"
    ask turtles
     [
      file-type who          file-type ","
      file-type ticks          file-type ","
      file-type wealth          file-type ","
      file-type profit          file-type ","
      file-type annual-risk          file-type ","
      file-type old-wealth          file-type ","
      file-type [profit] of old-patch          file-type ","
      file-type [annual-risk] of old-patch          file-type ","
      file-type count HiProfit-LowRisk-alts          file-type ","
      file-type count HiProfit-HiRisk-alts          file-type ","
      file-type count LowProfit-LowRisk-alts          file-type ","
      file-type count LowProfit-HiRisk-alts          file-type ","
      file-print current-utility
     ]
   file-close

end


to-report random-bernoulli [probability-true]

  ; First, do some defensive programming to make sure "probability-true"
  ; has a sensible value

  if (probability-true < 0.0 or probability-true > 1.0)
    [
      type "Warning in random-bernoulli: probability-true equals "
      print probability-true
    ]

  if-else random-float 1.0 < probability-true
  [report true]
  [report false]

end
@#$#@#$#@
GRAPHICS-WINDOW
446
10
834
399
-1
-1
20.0
1
8
1
1
1
0
0
0
1
-9
9
-9
9
1
1
1
ticks
30.0

BUTTON
11
10
74
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
89
10
152
43
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
165
11
228
44
step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
11
91
211
241
UtilityHistogram
NIL
NIL
0.0
500000.0
0.0
10.0
false
false
"" ""
PENS
"default" 10000.0 1 -16777216 true "" ""

PLOT
242
10
442
160
Mean Profit
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

PLOT
243
163
443
313
Mean Risk
NIL
NIL
0.0
10.0
0.0
0.1
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

PLOT
10
248
210
398
Mean Investor Wealth
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

@#$#@#$#@
# BusinessInvestors_Ch15-Ex8_2ndEd.nlogo

This file is provided as instructor materials for Chapter 15 of _Agent-based and Individual-based Modeling, 2nd edition_, by Railsback and Grimm (2019). Please do not copy or distribute this file. It is available upon request from www.railsback-grimm-abm-book.com.

This file is copyrighted 2019 by Steven F. Railsback and Volker Grimm.

The original Business Investor model described in Section 10.4.1 is modified here to use a stochastic adaptive trait, parameterized with empirical data, for selecting business opportunities. This modification is described in Section 15.4.

This version was updated for the 2nd edition of the book.

## 1. Purpose and patterns

The primary purpose of this version of the Business Investor model is to illustrate a way to model adaptive behavior using stochastic processes to reproduce empirical information. The model uses investment decisions as an example, but is not intended to represent any real investment approach or business sector.

This model could be thought of as approximately representing people who buy and operate local businesses: it assumes investors are familiar with investment opportunities within a limited range of their own experience, and that there is no cost of entering or switching investments (e.g., as if capital to buy a business is borrowed and the repayment is included in the annual profit calculation).

## 2. State variables and scales

The entities in this model are investor agents (turtles) and business alternatives (patches) that vary in profit and risk. The investors have state variables for their location in the space and for their current wealth (W, in money units).

The landscape is a grid of business patches, which each have two static variables: the annual net profit (P; in money units such as dollars per year) the business there provides, and the annual risk of the business there failing and its investor losing all its wealth (F; probability per year). This landscape is 19 by 19 patches in size with no wrapping at its edges. The values of P and F vary among patches randomly, within defined ranges. 

The model time step is one year, and simulations run for 25 years.

## 3. Process overview and scheduling

The model includes the following actions that are executed in this order each time step.

Investor repositioning: The investors decide whether any similar business (adjacent patch) offers a better tradeoff of profit and risk; if so, they "reposition" and transfer their investment to that patch, by moving there. Only one investor can occupy a patch at a time. The agents execute this action in randomized order.

Accounting: The investors update their wealth state variable. Wealth is set equal to the previous wealth plus the profit of the agent's current patch. However, unexpected failure of the business is also included in the accounting action. This event is a stochastic function of F at the investor's patch. If a uniform random number between zero and one is less than F, then the business fails and the investor's wealth becomes zero.

Output: The world display, plots, and an output file are updated. 

## 4. Design concepts

Emergence: The model's primary output is mean investor wealth, over time. Important secondary outputs are the mean profit and risk chosen by investors over time, and the number of investors who have suffered a failure. These outputs emerge from how individual investors make their tradeoffs between profit and risk, but also from the "business climate": the ranges of P and F values among patches and the number of investors competing for locations on the landscape.

Adaptive behavior: The adaptive behavior of investor agents is their decision of which neighboring business to move to (or whether to stay put), considering the profit and risk of these alternatives. Each time step, investors can reposition to any unoccupied one of their adjacent patches, or retain their current position. In this version of the model, investors use a stochastic process for adaptive behavior. "Empirical" parameters define the frequency with which investors have been observed to move to different alternatives (higher risk and higher profit than their current business, lower risk and lower profit, etc.). Whether or not each agent chooses each such alternative is determined by a pseudorandom number.

Objective: In this version, the agents do not use an explicit objective function in their adaptive behavior. 

Prediction: This version does not assume the investor agents use prediction.  

Sensing: The investor agents are assumed to know the profit and risk at their own patch and the eight neighbor patches, without error. 

Interaction: The investors interact with each other only indirectly via competition for patches: an investor cannot take over a business (move into a patch) that is already occupied by another investor. Investors execute their repositioning action in randomized order, so there is no hierarchy in this competition: investors with higher wealth have no advantage over others in competing for locations. 

Stochasticity: The initial state of the model is stochastic: the values of P and F of each patch, and initial investor locations, are set randomly. Stochasticity is thus used to simulate an investment environment where alternatives are highly variable and risk is not correlated with profit. Whether each investor fails each year is also stochastic, a simple way to represent risk. 

The investor reposition action uses stochasticity to determine whether the investor moves to any of its neighbor patches and, if it moves, which patch it selects, as described below for the repositioning submodel. 

Observation: The world display shows the location of each agent on the investment landscape. Graphs show the mean profit and risk experienced by investors, and mean investor wealth over time. An output file reports the state of each investor at each time step.

Learning and collectives are not represented. 

## 5. Initialization

Four model parameters are used to initialize the investment landscape. These define the minimum and maximum values of P (1,000 and 10,000) and F (0.1 and 0.01). The values of P and F for each patch are drawn randomly from uniform real number distributions with these minimum and maximum values. 

One hundred investor agents are initialized and put in random patches, but investors cannot be placed in a patch already occupied by another investor. Their wealth state variable W is initialized to zero. 

## 6. Input data

No time-series inputs are used.

## 7. Submodels

Investor repositioning: An agent identifies all the business alternatives that it could "reposition" by moving to: the neighboring eight (or fewer, if on the edge of the space) patches that are unoccupied. The agent then conducts these steps:

1. Determine if there are any alternatives with higher profits and lower risks. If so, determine whether a random Bernoulli trial is true for a probability of moving equal to 0.80. If the trial is true, then move to a randomly selected one of these higher-profit, lower-risk alternatives.

2. Determine if there are any alternatives with higher profits and higher risks. If so, determine whether a random Bernoulli trial is true for a probability of moving equal to 0.051. If the trial is true, then move to a randomly selected one of these alternatives.

3. Repeat the previous step for any alternatives with lower profits and lower risks, using a probability of selecting such an alternative equal to 0.032.

(Agents never move to alternatives with lower profits and higher risks.)

Accounting: This action is fully described above ("Process overview and scheduling").
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
