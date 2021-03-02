; NetLogo code by Mayfield Reynolds    01/12/2012
; Based on Cane Toad module by Drs. Shiflet

globals [ ALIVE AWP AMT_AWP_ADJACENT AMT_AWP_OVER2 AMT_AWP BORDER
  DEAD DESERT FENCED_AWP MIGRATED MOIST_AREA PERMANENT_WATER MAX_FOOD]
breed [ toads toad ]
toads-own [ energy water state numTimeSteps lastx lasty ]
patches-own [ food moisture class ]

; initialize background and toads
to init
  clear-all
  resize-world (0 - SIDE) SIDE (0 - SIDE) SIDE
  
  set AMT_AWP 1.0
  set PERMANENT_WATER 1.0
  
  set DEAD 0
  set ALIVE 1
  set MIGRATED 2
  
  set DESERT 0
  set AWP 1
  set FENCED_AWP 2
  set AMT_AWP_ADJACENT 0.4
  set AMT_AWP_OVER2 0.2
  set MOIST_AREA 5
  set BORDER 6
  
  initFood
  set MAX_FOOD max [food] of patches
  initMoisture
  initToads
  
  reset-ticks
end


; initialize moisture.  The desert landscape has been initialized with fenced and unfenced AWPs.
to initMoisture
  ask patches [
    ifelse ( (abs pxcor) < SIDE and (abs pycor) < SIDE ) [
      set class DESERT
      set pcolor scale-color grey food (MAX_FOOD * 2) 0 ;Have the color of the patch reflect the amount of food
    ] [
      set class BORDER
      set pcolor grey - 3
      ifelse ( (abs pycor) = SIDE ) 
      [set plabel "-"] [set plabel "|"]
    ]
  ]
  ask patches [
    if ((abs pxcor) < SIDE - 2 and (abs pycor) < SIDE - 2 and
           8 = count neighbors with [class = DESERT] and
           random-float 1 < (PERCENT_AWPS / 100)) [
      set moisture AMT_AWP
      ifelse (random-float 1 < (PERCENT_AWPS_FENCED / 100))
        [ set class FENCED_AWP
          set pcolor black
          set plabel "♦ " ]
        [ set class AWP
          set pcolor black ]
      ask neighbors [
        set moisture AWP_R1
        set class AMT_AWP_ADJACENT
        set plabel-color grey
        set pcolor black
        set plabel "#"
      ]
      ask neighbors [
        ask neighbors with [class = DESERT] [
          set moisture AWP_R2
          set class AMT_AWP_OVER2
          set pcolor white
          set plabel-color black
          set plabel "//"
        ]
      ]
    ]
  ]
end

; initialize food in desert
to initFood
  ask patches [
    ifelse (max list (abs pxcor) (abs pycor) = SIDE)
    [ set food -1 
      set moisture -1 
    ]
    [ set food FOOD_CELL]
  ]
end


; A random number of toads are on the east border; initialize toads
; AMT_MIN_INIT and INIT_RANGE are global variables indicating the minimum 
; energy/water amounts and length of interval of values, respectively.
to initToads
  set-default-shape toads "toad"
  ask patches with [ pxcor = SIDE ] [
    if (random-float 1 < INIT_PERCENT_TOADS / 100) [
      sprout-toads 1 [
        set size 1.5
        set state ALIVE
        set lastx -1
        set lasty -1
        set energy AMT_MIN_INIT + (random-float INIT_RANGE)
        set water  AMT_MIN_INIT + (random-float INIT_RANGE)
        set numTimeSteps 0
        set color cyan
        set xcor SIDE - 1
        set ycor SIDE - 1 - random (SIDE * 2 - 1)
        set heading -90
      ]
    ]
  ]
end

; simulation: repeatedly consumption, movement, then remove dead and migrated toads
to go
  if (count toads with [ state = ALIVE ] < 1) [ stop ]
  tick
  ask toads with [state = ALIVE] [
    if (energy < WOULD_LIKE_EAT or (water < WOULD_LIKE_DRINK and random-float 1 < MAY_EAT))
      [ eat ]
    if (moisture >= AMT_AWP and water < WOULD_LIKE_DRINK)
      [ drink ]
  ]
  ask toads with [state = ALIVE] [
    ifelse (water < WOULD_LIKE_DRINK) [
        thirsty
      ] [
      ifelse (energy < WOULD_LIKE_EAT) [
        lookForFood
      ] [
        ifelse (random-float 1 < MAY_HOP) [
          hopForFun
        ] [
          useWaterEnergySitting
        ]
      ]
    ]
    changeState
  ]
  ask patches with [class = DESERT] [set pcolor scale-color grey food (MAX_FOOD * 2) 0]
end

; Function to update a toad's energy and water after it eats
to eat
  let amtEat min (list AMT_EAT food (1 - energy))
  set energy energy + amtEat
  set water min list (water + FRACTION_WATER * amtEat) 1.0
  set food food - amtEat
end

to drink
  set water min list (AMT_DRINK + water) 1
end

; Procedure to update toad's water and energy after sitting for a time step
to useWaterEnergySitting
  if moisture < MOIST_AREA [ set water water - 0.5 * ENERGY_HOPPING ]
  set energy energy - 0.5 * ENERGY_HOPPING
end

to veryThirsty
  if (moisture < AWP) [ lookForMoisture ]
end

; Function to change the position of a very thirsty toad
to thirsty
  ifelse (moisture < MOIST_AREA) [
    lookForMoisture
  ][
    set numTimeSteps numTimeSteps + 1
    if (1 / numTimeSteps) < random-float 1 [
      set numTimeSteps 0
      lookForMoisture
    ]
  ]
end

;for some reason, lastx and lasty could not be used in this method,
; so the parameters lastxx and lastyy were used instead
to-report getNbrsLst [lastxx lastyy numNeighbors elimPrevious]
  let matLst []
  if numNeighbors = 4 [ set matLst neighbors4 ]
  if numNeighbors = 5 [ set matLst (patch-set neighbors4 patch-here) ]
  if numNeighbors = 8 [ set matLst neighbors ]
  if numNeighbors = 9 [ set matLst (patch-set neighbors patch-here) ]
  set matLst matLst with [class != FENCED_AWP and class != BORDER]
  if elimPrevious [
    set matLst matLst with [pxcor != lastxx or pycor != lastyy]
  ]
  report matLst
end

; Function to update a toad's location to hop in a random "legal" direction if possible
to hopForFun
  let loc one-of getNbrsLst lastx lasty NUM_NEIGHBORS false
  face loc
  move-to loc
  useWaterEnergyHopping
end

; Procedure to have toad look for food
to lookForFood
  set lastx pxcor
  set lasty pycor
  let matLst getNbrsLst lastx lasty (NUM_NEIGHBORS + 1) false
  let next hopToMax matLst true
  face next
  move-to next
  ifelse [pxcor] of next = lastx and [pycor] of next = lasty [
    useWaterEnergySitting
  ] [
    useWaterEnergyHopping
  ]
end

; Procedure to have toad look for moisture
to lookForMoisture
  set lastx pxcor
  set lasty pycor
  let matLst getNbrsLst lastx lasty NUM_NEIGHBORS true
  let next hopToMax matLst false
  face next
  move-to next
  useWaterEnergyHopping
end

; Procedure for to hop to maximum food or moisture
to-report hopToMax [matLst food?]
  ifelse food? [
    report max-one-of matLst [food]
  ] [
    report max-one-of matLst [moisture]
  ]
end

; Procedure to update toad's water and energy after a hop
to useWaterEnergyHopping
  if moisture < MOIST_AREA [ set water water - WATER_HOPPING ]
  set energy energy - ENERGY_HOPPING
end

; Method to eliminate a toad that should be dead or migrated
to changeState
  ifelse water < DESICCATE or energy < STARVE [
    set state DEAD
    move-to patch (SIDE + 1) (SIDE + 1)
  ] [
    if xcor = 1 - SIDE [
      set state MIGRATED
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
349
286
869
827
42
42
6.0
1
9
1
1
1
0
1
1
1
-42
42
-42
42
0
0
1
ticks
30.0

SLIDER
358
246
471
279
AMT_DRINK
AMT_DRINK
0
.2
0.05
.01
1
NIL
HORIZONTAL

SLIDER
482
246
584
279
AMT_EAT
AMT_EAT
0
.03
0.01
.005
1
NIL
HORIZONTAL

TEXTBOX
367
220
467
242
Maximum amount toad drinks in 1 time step
9
0.0
1

TEXTBOX
487
220
587
242
Maximum amount toad eats in 1 time step
9
0.0
1

TEXTBOX
456
13
558
35
Moisture value of neigh- boring cell to water
9
0.0
1

TEXTBOX
574
13
686
35
Moisture value of cell 2 cells away from water
9
0.0
1

TEXTBOX
555
150
653
174
Level at which desiccation occurs
9
0.0
1

TEXTBOX
186
216
324
238
Maximum amount of energy used by toad in a hop
9
0.0
1

TEXTBOX
13
83
120
105
Food value for initializing constant food grid\n
9
0.0
1

TEXTBOX
14
153
93
176
Probability of eating if thirsty
9
0.0
1

TEXTBOX
109
153
203
175
Probability of hopping if not thirsty or hungry
9
0.0
1

TEXTBOX
501
74
605
100
Number of neighbors not including self
9
0.0
1

TEXTBOX
601
226
733
251
Fraction of prey that is water
9
0.0
1

TEXTBOX
4
10
94
35
Number of cells along one side of grid
9
0.0
1

TEXTBOX
668
152
740
175
Level at which starvation occurs
9
0.0
1

TEXTBOX
30
218
158
241
Maximum amount of water used by toad in a hop
9
0.0
1

TEXTBOX
384
151
501
174
Water level at which toad would like to drink
9
0.0
1

TEXTBOX
245
151
352
178
Food level at which toad would like to eat
9
0.0
1

SLIDER
451
39
558
72
AWP_R1
AWP_R1
0
.6
0.4
.05
1
NIL
HORIZONTAL

SLIDER
568
39
674
72
AWP_R2
AWP_R2
0
.4
0.2
.25
1
NIL
HORIZONTAL

SLIDER
540
177
648
210
DESICCATE
DESICCATE
0
.8
0.6
.05
1
NIL
HORIZONTAL

SLIDER
182
244
346
277
ENERGY_HOPPING
ENERGY_HOPPING
0
.01
0
.001
1
NIL
HORIZONTAL

SLIDER
0
109
120
142
FOOD_CELL
FOOD_CELL
0
.1
0.05
.005
1
NIL
HORIZONTAL

SLIDER
-1
179
91
212
MAY_EAT
MAY_EAT
0
.4
0.4
.2
1
NIL
HORIZONTAL

SLIDER
101
179
207
212
MAY_HOP
MAY_HOP
0
1
0.4
.05
1
NIL
HORIZONTAL

CHOOSER
496
100
607
145
NUM_NEIGHBORS
NUM_NEIGHBORS
4 8
0

SLIDER
593
245
751
278
FRACTION_WATER
FRACTION_WATER
0
1
0.6
.05
1
NIL
HORIZONTAL

SLIDER
-3
38
102
71
SIDE
SIDE
0
100
42
1
1
NIL
HORIZONTAL

SLIDER
655
178
747
211
STARVE
STARVE
0
1
0.6
.05
1
NIL
HORIZONTAL

SLIDER
3
244
159
277
WATER_HOPPING
WATER_HOPPING
0
.01
0.0020
.0005
1
NIL
HORIZONTAL

SLIDER
377
177
531
210
WOULD_LIKE_DRINK
WOULD_LIKE_DRINK
0
1
0.9
.05
1
NIL
HORIZONTAL

SLIDER
219
177
365
210
WOULD_LIKE_EAT
WOULD_LIKE_EAT
0
1
0.9
.05
1
NIL
HORIZONTAL

BUTTON
13
300
90
333
Initialize
init
NIL
1
T
OBSERVER
NIL
I
NIL
NIL
1

SLIDER
114
39
252
72
PERCENT_AWPS
PERCENT_AWPS
0
20
1.2
.1
1
%
HORIZONTAL

SLIDER
267
39
442
72
PERCENT_AWPS_FENCED
PERCENT_AWPS_FENCED
0
100
53
1
1
%
HORIZONTAL

TEXTBOX
120
10
270
32
Percent chance of a desert block being initialized as an AWP
9
0.0
1

TEXTBOX
289
10
439
32
Percent chance of an AWP being surrounded by a fence
9
0.0
1

BUTTON
102
301
165
334
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
130
108
303
141
AMT_MIN_INIT
AMT_MIN_INIT
0
1
0.88
0.01
1
NIL
HORIZONTAL

SLIDER
614
101
804
134
INIT_PERCENT_TOADS
INIT_PERCENT_TOADS
0
100
61
1
1
NIL
HORIZONTAL

SLIDER
310
107
483
140
INIT_RANGE
INIT_RANGE
0
1
0.12
0.01
1
NIL
HORIZONTAL

MONITOR
20
368
116
413
Number Alive
count toads with [ state = ALIVE ]
17
1
11

MONITOR
127
369
245
414
Number Croaked
count toads with [ state = DEAD ]
17
1
11

MONITOR
70
427
190
472
Number Migrated
count toads with [ state = MIGRATED ]
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

CaneToads.nlogo
Module 11.4
Model to study the effect of fencing artificial water points (AWPs) on adult cane toad invasion.

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

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

toad
true
0
Polygon -7500403 true true 115 84 104 85 92 92 84 101 80 115 77 134 80 149 82 156 69 145 48 134 30 127 22 124 22 143 24 162 30 179 41 193 53 202 68 212 76 214 57 218 38 223 27 230 34 230 38 237 49 236 61 240 104 226 112 236 99 239 93 244 97 249 111 245 100 253 103 257 111 254 111 257
Polygon -7500403 true true 110 252 117 247 113 256 111 259 111 262 111 264 119 262 124 252 126 244 127 229 126 219 127 212 131 202 127 219 137 226 155 229 173 229 182 225 183 236 182 245 183 254 194 265 199 263 200 257 198 252 203 256 207 261 211 259 212 254 210 252 216 251 219 249 219 245 212 241 199 238 200 235 223 237 238 241 253 245 256 238 262 232 272 230 275 225 287 218 260 216 239 215 233 215 265 188 276 168 283 145 284 125 264 131 249 138 238 146 226 158 224 161 224 128 222 108 216 98 206 90 194 87 186 86 167 94 135 92 111 98
Polygon -7500403 true true 114 84 120 89 125 93 130 93 114 103
Circle -1 true false 114 52 40
Circle -1 true false 155 52 38
Circle -16777216 true false 131 65 10
Circle -16777216 true false 165 64 10
Circle -1 true false 169 68 2
Circle -1 true false 135 69 2
Polygon -7500403 true true 218 100 211 94 209 89 197 85 188 84 186 88
Circle -16777216 false false 101 91 12
Circle -16777216 false false 208 106 12
Polygon -16777216 false false 114 118 119 121 125 124 134 128 143 131 152 132 162 130 176 125 188 119 191 122 198 125 194 121 189 115 187 110 186 115 187 119 178 123 168 125 159 127 151 127 135 125 115 118 114 118 117 111 116 110 111 115 106 120 103 122 114 119
Circle -16777216 false false 200 149 16
Circle -16777216 false false 43 140 14
Circle -16777216 false false 62 160 22
Polygon -16777216 true false 31 145 33 153 40 166 52 180 64 192 82 203 104 212 78 197 64 187 48 171 38 158
Polygon -16777216 true false 223 134 220 154 216 172 210 190 204 200 215 184 221 167
Polygon -16777216 true false 80 131 82 143 86 162 93 184 101 197 86 171 80 152 78 136 79 124
Polygon -16777216 true false 110 182 106 194 104 210 104 223 108 232 108 212 109 188
Polygon -16777216 true false 70 222 53 227 43 231 62 228
Polygon -16777216 true false 172 199 177 210 182 224 183 220 180 211
Polygon -16777216 true false 193 183 200 194 201 210 200 225 199 237 204 218 204 199
Polygon -16777216 true false 196 261 197 251 194 246 198 248 199 255
Polygon -16777216 true false 200 243 211 251 211 247 203 243
Polygon -16777216 true false 205 217 221 207 242 187 256 169 265 154 261 159 245 179 232 193 219 204
Polygon -16777216 true false 236 223 250 222 262 224 265 227
Polygon -16777216 true false 233 214 220 220 203 225 215 224
Polygon -16777216 true false 72 212 92 217 103 220 86 215 70 209
Circle -16777216 false false 88 152 12
Circle -16777216 false false 82 117 16
Circle -16777216 false false 239 141 20
Circle -16777216 false false 223 166 14
Polygon -7500403 true true 117 82 124 92
Polygon -7500403 true true 138 93 146 89 154 78 158 82 164 88 174 92 168 105 145 102
Polygon -7500403 true true 131 93 123 89 117 84 110 84 118 92
Polygon -7500403 true true 122 89 135 93 126 98

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
NetLogo 5.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
