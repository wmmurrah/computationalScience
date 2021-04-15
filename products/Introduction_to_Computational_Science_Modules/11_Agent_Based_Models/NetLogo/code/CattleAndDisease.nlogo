; NetLogo code by Mayfield Reynolds    07/18/2013
; Based on Cattle module by Drs. Shiflet

globals [numS numI numR numM numCattle cumulativeI]
breed [ cattle cow ]
cattle-own[weight state daysSick time1InSale time2InSale]
patches-own[agentType]

to setup
  clear-all

  ;Setting up the turtles
  set-default-shape cattle "cow"

  ;Initializing infected calf
  let infectedCalfMade false


  ask patches [
    ;Section to divide up the simulation screen
    ifelse pycor <= round (- world-height * .3) [

      ;Section to setup the roads
      ifelse pycor = round (- world-height * .3) [
        set pcolor grey + 3

        ;Sets up the patch label for Road to the East
        if pxcor < 0 [
          set agentType "RoadEast"
          set plabel "\\\\\\"
        ]
        if pxcor = 0 [
          set agentType "Down Pointer"
        ]

        ;Sets up the patch label for Road to the West
        if pxcor > 0 [
          set agentType "RoadWest"
          set plabel "///"
        ]
        set plabel-color black + 2
      ]
      [
        ;Setup for the bottom left-side of the simulation screen
        ifelse pxcor <= 0 [

          ;Setting up the vertical grey bar that divide sale barn and stocker
          ifelse pxcor = 0 [
            set agentType "SaleBarn"
            set pcolor grey - 3
          ]

          ;Making the Stocker grey
          [
            set agentType "Stocker"
            set pcolor grey + 1
          ]
        ]
        [
          ;Setting up the Feed lot and the burger joint
          ifelse pxcor <= round(world-width / 4) [

            ;vertical bar to divide the Feedlot and the burger joint
            ifelse pxcor = round(world-width / 4) [
              set agentType "Abattoir"
              set pcolor black
              set plabel ":::"
            ]

            ;Making the Feedlot grey
            [
              set agentType "Feedlot"
              set pcolor grey - 1
            ]
          ]

          ;Making the burger joint White
          [
            set agentType "Burger Joint"
            set pcolor white
          ]
        ]
      ]
    ]

    ;Sets up the white vertical borders between the farms
    [
      ifelse pxcor mod (round (world-width / 6)) = 0 [
        set agentType "Border"
        set pcolor white
      ]

      ;Sets the farms
      [
        set agentType "Farm"
      ]
    ]
  ]

  ;Initiates calf and sick cattle and initiates the count
  ask patches with [ agentType = "Farm" ] [
    if (random-float 1 < INIT_CATTLE_FRACTION) [
      sprout-cattle 1 [
        set weight random-float 40 + 60
        ifelse (infectedCalfMade) [
          set state "Cattle"
          set color cyan
        ]
        [
          set state "Infected"
          set color white
          set daysSick 0
          set infectedCalfMade true
        ]
        if weight_label [ set label round weight ]
      ]
    ]
  ]
  countSIRM
  reset-ticks
end



to go
  ;Stops simulation when all cattle die
  if (numS + numI + numR + numM = 0) [
    stop
  ]

  ask cattle [
    ;Kills cow if they are in the abattoir and decrements the count
    ifelse ([agentType] of patch-here) = "Abattoir" [
      sirAbattoir
      set heading 90
      forward 1
      set state "Slaughtered"
      set shape "dead cow"
      set label ""
    ]
    [
      sir
      let atype [agentType] of patch-here


      if atype = "Farm" or atype = "RoadWest" or atype = "RoadEast" or atype = "Down Pointer" [

        ;Moves cattle from farm to farm sale if it is 600 pounds or more
        ifelse (weight < 600) [inFarm] [farm2Sale]
      ]
      ;Moves cattle back to the salebarn to be sold to the feedlot when it gets to 900 pounds
      if atype = "SaleBarn" [
        ifelse (weight < 900) [inSaleBarn1] [inSaleBarn2]
      ]

      ;Moves the cattle to a stocker (gaining weight)
      if atype = "Stocker" [
        inStocker
      ]

      ;Moves the cattle to a feed lot
      if atype = "Feedlot" [
        inFeedlot
      ]

      ;Resets the weight_label if sick and doesn't otherwise
      ifelse weight_label [ set label round weight ] [ set label "" ]
    ]
  ]
  tick
end


;Procedure to initiate counting variables
to countSIRM
  set numS count cattle with [state = "Cattle"]
  set numI count cattle with [state = "Infected"]
  set numR count cattle with [state = "Recovered"]
  set numM count cattle with [state = "Immune"]
  set cumulativeI numI
  set numCattle count cattle
end

;Procedure to check where cattle is infected or not
to sir
  ;checks if cattle is still infectious or recovered
  if state = "Infected" [

    ;If recovered, change state, shape, daysSick, decrement num of days infected and increment num of days recovered
    ifelse daysSick > INFECTIOUS_PERIOD [
      set state "Recovered"
      set color cyan
      set shape "recovered cow"
      set daysSick 0
      set numI numI - 1
      set numR numR + 1
    ]

    ;Otherwise, increment on the days sick
    [
      set daysSick daysSick + .25
    ]
  ]

  ;If cattle is healthy but around infectious cattle, cattle gets infected
  if state = "Cattle" and
        (sum [count turtles-here with [ state = "Infected" ]] of neighbors) > 0
        and random-float 1 < INFECTION_PROBABILITY [
    set state "Infected"
    set color white
    set numS numS - 1
    set numI numI + 1
    set cumulativeI cumulativeI + 1
    set daysSick 0
  ]
end

to inFarm

;If cattle is in farm, gains weight
  set weight weight + .5 + random-float .25

  ; Set new variable p to an empty patch in the farm
  let p one-of neighbors with [ agentType = "Farm" ] with [ count cattle-here = 0 ]

  ;If p has agent, set cattle heading towards p and moves to the same point as p
  if p != nobody [
    face p
    move-to p
  ]
end


to farm2Sale
  ; turns the patch 1 to the south
  let south patch-at-heading-and-distance 180 1
    ; turns the patch 1 to the east
  let east patch-at-heading-and-distance 90 1
    ; turns the patch 1 to the west
  let west patch-at-heading-and-distance -90 1

  ;If agent type of south is farm and empty, set heading to south and move it to south
  ifelse [agentType] of south = "Farm" [
    if count cattle-on south = 0 [
      face south
      move-to south
    ]
  ]

  ;Otherwise
  [

    ;If agent type of south is in Road to west, and there is no cattle at patch in sqrt 2 distance
    ;in the south-west direction, then set heading to south west and move sqrt 2 distance.
    ifelse [agentType] of south = "RoadWest" [
      if count cattle-on patch-at-heading-and-distance 225 sqrt 2 = 0 [
        set heading 225
        fd sqrt 2   ;same as forward 1
      ]
    ]
    ;If agent type of west is in Road to west or in the down pointer and there is no cattle in west,
    ;set heading to west and move distance 1 towards west.
    [
      ifelse [agentType] of west = "RoadWest" or [agentType] of west = "Down Pointer" [
        if count cattle-on west = 0 [
          face west
          move-to west
        ]
      ]
      [
        ;If agent type of south is in the road to east, and there is no cattle in distance sqrt of 1
        ;in the south east direction, then, move the agent type in distance sqrt of 1 in the south
        ;direction
        ifelse [agentType] of south = "RoadEast" [
          if count cattle-on patch-at-heading-and-distance 135 sqrt 2 = 0 [
            set heading 135
            fd sqrt 2
          ]
        ]
        [
          ;If agent type of east is in the road to east or in the down pointer, and there is no cattle
          ;on its east, then set its heading towards the east and move
          ifelse [agentType] of east = "RoadEast" or [agentType] of east = "Down Pointer" [
            if count cattle-on east = 0 [
              face east
              move-to east
            ]
          ]
          [
            ;If agent type of south is in the sale barn, set its heading towards the south and move and set
            ;its time in sale barn1 to be a random number between 1 and 6
            if [agentType] of south = "SaleBarn" [
              face south
              move-to south
              set time1InSale 1 + random 5
            ]
          ]
        ]
      ]
    ]
  ]
end

;Procedure to check the agent's time in salebarn1 and move it towards the west
to inSaleBarn1
  ;moves towards the west if its time in salebarn1 is greater than 8
  ifelse time1InSale > 8 [
    set heading -90
    fd 1
  ]
  ;keeps it in salebarn1 if time in the sale barn is less than or equal to 8
  [
    set time1InSale time1InSale + 1
    moveInSaleBarn
  ]
end

;Procedure to move agent to the vertical bar that divides the salebarns and the stocker
to moveInSaleBarn
  let p one-of neighbors with [agentType = "SaleBarn"]
  face p
  move-to p
end

;stocker Procedure receives cattle from sale barns at 600 pounds and fattens them to 900 pounds
;And they go to feed lots
to inStocker
  ;if weight is greater than 900 pounds, move 1 distance towards the east (the feed lot)
  ifelse weight >= 900 [
    set heading 90
    forward 1

    ;if agent is is a sale barn, then set the time spent in the second salebarn to a number between 1 and 6
    if [agentType] of patch-here = "SaleBarn" [
      set time2InSale  1 + random 5
    ]
  ]
  [
    ;cattle in stocker moves and gains weight.
    let p one-of neighbors with [agentType = "Stocker"]
    face p
    move-to p
    set weight weight + .4 + random-float .2
  ]
end

;Procedure to move agent towards the east in the salebarn and increment time in the salebarn
to inSaleBarn2
  ifelse time2InSale > 8 [
    set heading 90
    fd 1
  ]
  [
    set time2InSale time2InSale + 1
    moveInSaleBarn
  ]
end

;Procedure gets cattle that is 900 pounds or more, feeds it until it gets to 1300 pounds and moves it towards
;the abattoir.
to inFeedlot
  ;if cattle is 1300 or more start moving it towards the abattoir(east)
  ifelse weight >= 1300 [
    set heading 90
    fd 1
  ]
  ;Otherwise,
  [
    let south patch-at-heading-and-distance 180 1
    let north patch-at-heading-and-distance 0 1
    let east patch-at-heading-and-distance 90 1

    ;if the agent is in the feedlot and there is no cattle in distance 1 in the east direction,
    ;then move the agent to distance 1 towards the east
    ifelse [agentType] of east = "Feedlot" and count cattle-on east = 0 [
      face east
      fd 1
    ]

    [
      ;if the agent is in the feedlot and there is no cattle in distance 1 in the north direction,
      ;then move the agent to distance 1 towards the north
      ifelse [agentType] of north = "Feedlot" and count cattle-on north = 0 [
        face north
        fd 1
      ]
      [
        ;if the agent is in the feedlot and there is no cattle in distance 1 in the south direction,
        ;then move the agent to distance 1 towards the south
        if [agentType] of south = "Feedlot" and count cattle-on south = 0 [
          face south
          fd 1
        ]
      ]
    ]
    ;Add weight to the cattle
    set weight weight + .5 + random-float .5
  ]
end

;Procedure simulates the abattoir. Kills healthy cattle, infected, recovered and immune and decreaments their
;number
to sirAbattoir
  if state = "Cattle" [ set numS numS - 1 ]
  if state = "Infected" [ set numI numI - 1 ]
  if state = "Recovered" [ set numR numR - 1 ]
  if state = "Immune" [ set numM numM - 1 ]
end
@#$#@#$#@
GRAPHICS-WINDOW
212
12
830
631
-1
-1
10.0
1
10
1
1
1
0
1
1
1
-30
30
-30
30
0
0
1
ticks
30.0

SLIDER
12
79
202
112
INIT_CATTLE_FRACTION
INIT_CATTLE_FRACTION
0
1
0.16
.01
1
NIL
HORIZONTAL

BUTTON
28
30
92
63
Setup
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

MONITOR
35
285
92
330
Healthy
numS
17
1
11

MONITOR
111
285
171
330
Infected
numI
17
1
11

MONITOR
28
338
101
383
Recovered
numR
17
1
11

MONITOR
112
338
169
383
Immune
numM
17
1
11

MONITOR
20
397
90
442
NIL
numCattle
17
1
11

BUTTON
104
30
167
63
Go
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

SLIDER
12
120
202
153
INFECTIOUS_PERIOD
INFECTIOUS_PERIOD
0
250
241.0
1
1
days
HORIZONTAL

SWITCH
45
220
170
253
weight_label
weight_label
1
1
-1000

SLIDER
9
163
204
196
INFECTION_PROBABILITY
INFECTION_PROBABILITY
0
1
0.245
.005
1
NIL
HORIZONTAL

MONITOR
102
397
188
442
NIL
cumulativeI
17
1
11

@#$#@#$#@
## WHAT IS IT?

Introduction to Computational Science:
Modeling and Simulation for the Sciences, 2nd Edition

Angela B. Shiflet and George W. Shiflet
Wofford College
Copyright 2014 by Princeton University Press

CattleAndDisease.nlogo
Module 11.2

This model demonstrates the life of beef cattle in America and the process in which beef is produces from a calf. Each cattle follows a set of simple rules. The cattle move through stages according to its health and weight. Cattle can get infected through interaction with other infected cattle and they can die or recover.

In this model, we assume that recovered cattle cannot get sick again. One of the main killing infections is pinkeye and scientists suggest that it can be avoided but not easily. When cattle reached 1300 pound, it is slaughtered for beef.

## HOW IT WORKS

Cattle is divided into stages. Calves are born a weight between 60 and 100 pounds. Then, a calf roams freely on a farm or ranch for 6 to 9 months until reaching a weight of 600 pounds. Then calves from many sources are taken to sale barns to be sold as stockers.  As stockers, steers and heifers gain weight to 900 pounds
Feedlots buy these cattle at sale barns and fattened them in pens for 4 to 6 months until the animals reach weights between 1,200 and 1,400 pounds and then go to market for beef.

## HOW TO USE IT

Click the SETUP button to initiate numCattle, health, infected and other variables.Click the GO button to start the simulation.
INIT_CATTLE_FRACTION: This slider approximates the initial fraction of susceptible cattle and, in a sense, is a measure of the initial density of cattle on the farms.
INFECTIOUS PERIOD: This slider determines how many days the cattle gets sick.
INFECTION PROBABILITY: This slider influences the chances of cattle getting sick.


## THINGS TO NOTICE

Notice that we always start off with one sick cattle.

## THINGS TO TRY

Change the initial conditions and make the simulation faster.

## EXTENDING THE MODEL

This model assumes that sickness is the only factor affecting the cattle.

We can introduce a predator or make the amount of food limited.

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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

dead cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123
Line -16777216 false 45 75 210 180
Line -16777216 false 225 75 45 180

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

immune cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123
Rectangle -16777216 true false 30 90 271 101
Rectangle -16777216 true false 36 127 235 139
Rectangle -16777216 true false 48 164 217 176

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

recovered cow
false
4
Polygon -1184463 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -1184463 true true 73 210 86 251 62 249 48 208
Polygon -1184463 true true 25 114 16 195 9 204 23 213 25 200 39 123
Rectangle -16777216 true false 120 105 135 120
Rectangle -16777216 true false 210 105 225 120
Rectangle -16777216 true false 30 105 45 120
Rectangle -16777216 true false 75 120 90 135
Rectangle -16777216 true false 165 120 180 135
Rectangle -16777216 true false 195 90 210 105
Rectangle -16777216 true false 165 90 180 105
Rectangle -16777216 true false 135 90 150 105
Rectangle -16777216 true false 105 90 120 105
Rectangle -16777216 true false 75 90 90 105
Rectangle -7500403 true false 45 90 60 105
Rectangle -16777216 true false 60 135 75 150
Rectangle -16777216 true false 90 135 105 150
Rectangle -16777216 true false 120 135 135 150
Rectangle -16777216 true false 150 135 165 150
Rectangle -16777216 true false 180 135 195 150
Rectangle -16777216 true false 210 135 225 150
Rectangle -16777216 true false 225 90 240 105
Rectangle -16777216 true false 210 75 225 90
Rectangle -16777216 true false 180 165 195 180
Rectangle -16777216 true false 90 165 105 180
Rectangle -16777216 true false 60 224 75 239
Rectangle -7500403 true false 52 190 67 205
Rectangle -7500403 true false 180 180 195 195
Rectangle -16777216 true false 180 225 195 240
Rectangle -16777216 true false 255 90 270 105
Rectangle -16777216 true false 45 90 60 105
Rectangle -7500403 true false 30 90 45 105
Rectangle -7500403 true false 60 90 75 105
Rectangle -7500403 true false 90 90 105 105
Rectangle -7500403 true false 120 90 135 105
Rectangle -7500403 true false 150 90 165 105
Rectangle -7500403 true false 180 90 195 105
Rectangle -7500403 true false 210 90 225 105
Rectangle -7500403 true false 240 90 255 105
Rectangle -7500403 true false 30 120 45 135
Rectangle -7500403 true false 45 135 60 150
Rectangle -7500403 true false 75 135 90 150
Rectangle -7500403 true false 105 135 120 150
Rectangle -7500403 true false 135 135 150 150
Rectangle -7500403 true false 120 120 135 135
Rectangle -7500403 true false 75 105 90 120
Rectangle -7500403 true false 90 150 105 165
Rectangle -7500403 true false 165 135 180 150
Rectangle -7500403 true false 195 135 210 150
Rectangle -7500403 true false 165 105 180 120
Rectangle -7500403 true false 210 120 225 135
Rectangle -7500403 true false 210 120 225 135
Rectangle -16777216 true false 135 150 150 165
Rectangle -7500403 true false 135 165 150 180
Rectangle -16777216 true false 45 150 60 165
Rectangle -7500403 true false 180 150 195 165
Rectangle -7500403 true false 255 105 270 120

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

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

wolf
false
0
Polygon -7500403 true true 135 285 195 285 270 90 30 90 105 285
Polygon -7500403 true true 270 90 225 15 180 90
Polygon -7500403 true true 30 90 75 15 120 90
Circle -1 true false 183 138 24
Circle -1 true false 93 138 24

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
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
