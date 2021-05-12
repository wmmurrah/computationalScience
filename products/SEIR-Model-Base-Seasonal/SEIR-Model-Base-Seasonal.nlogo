;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

globals 
[ 
  r0-SEIR                      ;; Basic reproduction number, R0. 
  maximum-infectious           ;; The maximum number of infectious individuals at one simulation tick.  
  tick-at-maximum-infectious   ;; The (first) tick when the maximum number of infectious individuals is realized.  
  number-infectious-vector     ;; Vector of the number of infectious individuals at each simulation tick.  
  
  incubation-alpha             ;; Alpha parameter for the gamma distribution used in calculating incubation-time.
  incubation-lambda            ;; Lambda parameter for the gamma distribution used in calculating incubation-time.
  infectious-alpha             ;; Alpha parameter for the gamma distribution used in calculating infectious-time.
  infectious-lambda            ;; Lambda parameter for the gamma distribution used in calculating infectious-time.
]

turtles-own
[ 
  susceptible?             ;; If true, the individual is a member of the susceptible class.  
  exposed?                 ;; If true, the individual is a member of the exposed (incubation) class.
  infectious?              ;; If true, the individual is a member of the infectious class.
  recovered?               ;; If true, the individual is a member of the recovered class.
  
  incubation-length        ;; How long the individual has been in the exposed class, increasing by 1 each tick. This is compared against the incubation-time, selected from a gamma-distribution.
  incubation-time          ;; The randomly chosen gamma-distribution value for how long the individual will be in the exposed class.
  infectious-length        ;; How long the individual has been in the infectious class, increasing by 1 each tick. This is compared against the infectious-time, selected from a gamma-distribution.
  infectious-time          ;; The randomly chosen gamma-distribution value for how long the individual will be in the infectious class.
  
  total-contacts           ;; A count of all contacts of the individual.
]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Setup Procedures ;;;;

to setup
  clear-all
  setup-gamma-distributions
  setup-population
  reset-ticks 
end


to setup-gamma-distributions            ;; The calculation from mean and standard deviation (in days) to the alpha and lambda parameters required for the gamma-distributions (in ticks).  
  set incubation-alpha (average-incubation-period * ticks-per-day)^ 2 / (incubation-standard-deviation * ticks-per-day)^ 2    
  set incubation-lambda (average-incubation-period * ticks-per-day) / (incubation-standard-deviation * ticks-per-day)^ 2      
  set infectious-alpha (average-infectious-period * ticks-per-day)^ 2 / (infectious-standard-deviation * ticks-per-day)^ 2    
  set infectious-lambda (average-infectious-period * ticks-per-day) / (infectious-standard-deviation * ticks-per-day)^ 2      
end
  

to setup-population
  create-turtles initial-population   
  [
    setxy random-xcor random-ycor       ;; All individuals are placed on random patches in the world.
    
    set susceptible? true               ;; All individuals are set as susceptible.
    set exposed? false      
    set infectious? false       
    set recovered? false           
     
    set shape "person"
    
    set total-contacts 0
    
    ask turtle 0                        ;; Individual 0 begins as infectious.  Its infectious-time is selected from the gamma distribution and infectious-length set to 0.  
    [
      set susceptible? false
      set infectious? true
      set infectious-time random-gamma infectious-alpha infectious-lambda
      set infectious-length 0
    ]
    
   set number-infectious-vector [ 1 ]   ;; The number-infectious-vector vector is initiallized.  
   assign-color
  ]
end

to assign-color
  if susceptible?
    [ set color white ]
  if exposed?
    [ set color yellow ]
  if infectious?           
    [ set color red ]      
  if recovered?            
    [ set color lime ]
  
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Go Procedure ;;;;

to go
  if all? turtles [ susceptible? or recovered? ]         ;; The simulation ends when no individuals are infected (exposed or infectious).  
    [ stop ]                                                                                 
  
  ask turtles                                            
    [ move ]
    
  ask turtles with [ infectious? ]                       ;; Infectious individuals might expose susceptible neighbors.  If infectious individuals have been infectious for infectious-time ticks, they will recover.   
    [ expose-neighbors                                  
      chance-of-recovery ]                              
     
  ask turtles with [ exposed? ]                          ;; If exposed individuals have been in the exposed class for incubation-time ticks, they will become infectious.
    [ chance-of-becoming-infectious ]  
    
  ask turtles 
    [ assign-color 
      count-contacts ]

  compute-maximum-infectious  
  compute-r0-SEIR
  
  tick
  
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Nested Functions ;;;;

to move                                                                            ;; Individuals turn a random angle between -40 and 40 degrees then step forward 1 unit.  
  right (random 80) - 40
  forward 1
  if not can-move? 1 [ right 180 ]                                                 ;; If an individual is at the world's boundary, it turns around.
end

to count-contacts                                                                  ;; Contacts are defined as other individuals within a 1 unit radius.  
  set total-contacts total-contacts + count other turtles in-radius 1
end

to expose-neighbors
  ask other turtles in-radius 1 with [ susceptible? ]                              ;; Susceptible individuals who come into contact with an infectious individual will become infected with probability transmission-chance.
    [ 
      if random-float 100 < transmission-chance                                            
        [ 
          set susceptible? false  
          set exposed? true                                                                   
          set incubation-time random-gamma incubation-alpha incubation-lambda      ;; A newly exposed individual selects an incubation-time from the gamma-distribution and its incubation-length is set to 0.          
          set incubation-length 0                                                          
        ]             
    ]                                                              
end      

to chance-of-becoming-infectious                                                   ;; When an infected individual has been in the exposed class longer than its incubation-time, it will become infectious.  
  set incubation-length incubation-length + 1
  if incubation-length > incubation-time                                     
  [                                                                          
    set exposed? false
    set infectious? true                                                      
    set infectious-time random-gamma infectious-alpha infectious-lambda            ;; A newly infectious individual selects an infectious-time from the gamma-distribution and its infection-length is set to 0.
    set infectious-length 0                                                 
  ]
end

to chance-of-recovery                                                              ;; When an infectious individual has been in the infectious class longer than its infection-time, it will recover.
  set infectious-length infectious-length + 1
  if infectious-length > infectious-time                                     
  [                                                                          
    set infectious? false
    set recovered? true
  ]
end

to compute-maximum-infectious                                                      ;; A vector of the number of infectious individuals at each tick is stored.  The maximum and time of the maximum are computed.  
  set number-infectious-vector lput count turtles with [infectious?] number-infectious-vector
  set maximum-infectious max number-infectious-vector
  set tick-at-maximum-infectious position maximum-infectious number-infectious-vector   
end


to compute-r0-SEIR                                                                 ;; R0 is derived from the corresponding system of differential equations by integrating dS / dR = (beta*SI) / (nu*I).
  if ( ( count turtles with [ susceptible? ] ) != 0 and ( count turtles with [ recovered? ] ) != 0 )                           
  [ 
    set r0-SEIR ln ( ( initial-population - 1 ) / ( count turtles with [ susceptible? ] ) ) / ( count turtles with [ recovered? ] ) * ( initial-population - 1 ) 
  ]                                       
  
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@#$#@#$#@
GRAPHICS-WINDOW
644
10
1212
599
16
16
16.91
1
13
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
21
10
84
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
125
10
188
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

SLIDER
22
58
301
91
initial-population
initial-population
250
10000
1000
50
1
individuals
HORIZONTAL

SLIDER
22
140
301
173
transmission-chance
transmission-chance
1
20
5
1
1
percent
HORIZONTAL

SLIDER
22
263
301
296
average-infectious-period
average-infectious-period
0.5
14
5
0.5
1
days
HORIZONTAL

SLIDER
22
223
301
256
incubation-standard-deviation
incubation-standard-deviation
0.2
7
0.33
0.2
1
days
HORIZONTAL

SLIDER
22
182
301
215
average-incubation-period
average-incubation-period
0.2
7
1
0.2
1
days
HORIZONTAL

SLIDER
22
305
301
338
infectious-standard-deviation
infectious-standard-deviation
0.5
7
1.03
0.5
1
days
HORIZONTAL

PLOT
321
10
626
232
Outbreak profile in days 
Days
Number of individuals
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Susceptible" 1.0 0 -16777216 true "" "plotxy (ticks / ticks-per-day) count turtles with [ susceptible? ]"
"Exposed" 1.0 0 -1184463 true "" "plotxy (ticks / ticks-per-day) count turtles with [ exposed? ]"
"Infectious" 1.0 0 -2674135 true "" "plotxy (ticks / ticks-per-day) count turtles with [ infectious? ]"
"Recovered" 1.0 0 -13840069 true "" "plotxy (ticks / ticks-per-day) count turtles with [ recovered? ]"

SLIDER
22
99
301
132
ticks-per-day
ticks-per-day
1
24
4
1
1
ticks / day
HORIZONTAL

MONITOR
321
302
379
355
Days
ticks / ticks-per-day
3
1
13

MONITOR
478
240
544
293
Infectious
count turtles with [ infectious? ]
3
1
13

MONITOR
408
240
466
293
Exposed
count turtles with [ exposed? ]
3
1
13

MONITOR
555
240
626
293
Recovered
count turtles with [ recovered? ]
3
1
13

MONITOR
321
240
397
293
Susceptible
count turtles with [ susceptible? ]
3
1
13

BUTTON
224
10
301
43
go once
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

MONITOR
558
302
625
355
R0 (SEIR)
r0-SEIR
3
1
13

MONITOR
321
487
585
540
Population Mean of Average-Daily-Contacts
mean [ total-contacts / ( ticks / ticks-per-day ) ] of turtles
3
1
13

MONITOR
420
303
524
356
Attack Rate (%)
count turtles with [recovered?] * 100 / initial-population
3
1
13

MONITOR
321
363
516
416
Maximum Number of Infectious
maximum-infectious
3
1
13

MONITOR
321
425
609
478
Time of Maximum Number of Infectious (Days)
tick-at-maximum-infectious / ticks-per-day
3
1
13

@#$#@#$#@
## WHAT IS IT?

This is a basic susceptible-exposed-infectious-recovered (SEIR) model for seasonal influenza. The model uses gamma-distributions to determine the lengths of the incubation (latency) and infectious periods for each individual.

Susceptible individuals are white, exposed individuals are yellow, infectious individuals are red, and recovered individuals are green.

## HOW IT WORKS

Prior to the start of the simulation, a single individual is infectious; all others are susceptible.  Individuals move randomly in the world and turn around at the world's edge.  

When a susceptible individual comes into contact with an infectious individual there is a probability (chance) that the susceptible individual will become infected.  If a susceptible individual becomes infected, the individual moves into the exposed class.  After a gamma-distributed time, an exposed individual moves into the infectious class.  Infectious individuals are able to infect others.  After a gamma-distributed time, an infectious individual recovers and moves into the recovered class.  Recovered individuals gain permanent immunity.  

The model simulation ends when no individuals are infected (exposed or infectious).  

## HOW TO USE IT

The INITIAL-POPULATION slider sets the number of individuals; units = individuals.

The TICKS-PER-DAY slider sets the number of computational ticks that correspond to one day; units = ticks / day. 

The TRANSMISSION-CHANCE slider sets the probability that contact between an infectious individual and a susceptible individual will result in the susceptible individual becoming infected; units = percent.

The AVERAGE-INCUBATION-PERIOD slider sets the mean value of the incubation period, which is used in calculating the gamma-distribution for the time in the exposed class; units = days.  

The INCUBATION-STANDARD-DEVIATION slider sets the standard deviation of the incubation period, which is used in calculating the gamma-distribution for the time in the exposed class; units = days.  

The AVERAGE-INFECTIOUS-PERIOD slider sets the mean value of the infectious period, which is used in calculating the gamma-distribution for the time in the infectious class; units = days.

The INFECTIOUS-STANDARD-DEVIATION slider sets the standard deviation of the infectious period, which is used in calculating the gamma-distribution for the time in the infectious class; units = days.  

## THINGS TO NOTICE

During a simulation there are two possible results, determined by the basic reproduction number R0.  An R0 value that is larger than 1 indicates viral spread, while an R0 value less than 1 indicates viral extinction.  

One simulation result is that the disease spreads throughout the population causing an outbreak.  The graph of the number of infected individuals will show one distinct peak.  When an outbreak occurs the basic reproduction number, R0, will be larger than 1.  

The second simulation result is that the disease will die out quickly before causing an outbreak in the population.  When there is no outbreak the basic reproduction number, R0, will be less than 1.  


## RELATED MODELS

NetLogo Models Library:
epiDEM Basic
epiDEM Travel and Control
AIDS
Disease Solo

Seasonal influenza model:
Base Model (this model)

The following models for pandemic influenza and control strategies are modifications of the Base Seasonal Model.  

Pandemic influenza models:
Waning Immunity
Periodic Transmission Chance
Two Weakly-Interacting Subpopulations

The pandemic influenza models will result in two peaks in the number of infectious individuals with appropriate parameter selection.  

Control strategies for seasonal influenza:  
Quarantine
Isolation 
Antivirals
Seasonal Vaccination 
Pandemic Vaccination 

The models incorporating control strategies demonstrate the effect of different control strategies on the attack rate during an outbreak of seasonal (or pandemic) influenza.  


## CREDITS AND REFERENCES

Authors:
Roger Estep, Robert Hughes, and Jessica Shiltz, supervised by Dr. Anna Mummert. 
Work was completed as part of the Marshall University NSF-UBM grant.  
Marshall University, Huntington, WV, USA.
Summer 2013 -- Fall 2014.
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
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

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
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Sample Experiment" repetitions="300" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>r0-from-SEIR</metric>
    <metric>r0-from-generation-interval-doubling-time</metric>
    <metric>r0-from-generation-interval-regression</metric>
    <metric>r0-from-gamma-distribution-doubling-time</metric>
    <metric>r0-from-gamma-distribution-regression</metric>
    <metric>mean [average-daily-contacts] of turtles</metric>
    <metric>count turtles with [recovered?] / initial-population</metric>
    <metric>days</metric>
    <metric>maximum-infectious</metric>
    <metric>tick-at-maximum-infectious / ticks-per-day</metric>
    <enumeratedValueSet variable="initial-population">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infectious-standard-dev">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incubation-chance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-per-day">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-incubation-period">
      <value value="1.48"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incubation-standard-dev">
      <value value="0.47"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-infectious-period">
      <value value="4.1"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
