          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          ;;        AGENT_ZERO                  
          ;;     18th Brumaire Code. 
          ;;       Version 1.0 
          ;;                
          ;;      Joshua M. Epstein
          ;;         July 2012
          ;;          
          ;;   Sliders [100, 0, 4, 1, 10]
          ;;      Brumaire Seed : 2
          ;;
          ;;   Note: Includes code beyond
          ;;    minimum required for run.          
          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to use-new-seed
  let my-seed new-seed            
  output-print word "Generated seed: " my-seed  
  random-seed my-seed            
end

to use-seed-from-user
  let my-seed read-from-string user-input "Enter a random seed (an integer):"
  output-print word "User-entered seed: " my-seed  
  random-seed my-seed       
end

directed-link-breed [red-links red-link]

links-own [weight]

turtles-own [
            affect
            learning_rate
            lambda
            delta 
            age                                 
            threshold 
            event_count 
            disposition
            probability
            memory       
            ]

to setup-links

   ask turtle 0 [ create-red-link-to turtle 1]
                 ask red-link 0 1 [ 
                 set color red 
                 set weight 0.3]
   ask turtle 0 [ create-red-link-to turtle 2]
                 ask red-link 0 2 [ 
                 set color red 
                 set weight 0.3]
   ask turtle 1 [ create-red-link-to turtle 0]
                 ask red-link 1 0 [ 
                 set color red 
                 set weight 0.3]
   ask turtle 1 [ create-red-link-to turtle 2]
                 ask red-link 1 2 [ 
                 set color red 
                 set weight 0.3]
   ask turtle 2 [ create-red-link-to turtle 0]
                 ask red-link 2 0 [ 
                 set color red 
                 set weight 0.3]
   ask turtle 2 [ create-red-link-to turtle 1]
                 ask red-link 2 1 [ 
                 set color red 
                 set weight 0.3]
end

to setup
  __clear-all-and-reset-ticks
  ;use-new-seed 
  use-seed-from-user 
  setup-patches
  setup-turtles
; setup-links
; movie-start "out.mov"     ; Movie Code
; movie-grab-view          
; repeat 135 
;    [ go 
;    movie-grab-view ]
;   movie-close
 tick
end

to setup-turtles
  set-default-shape turtles "person"
  create-turtles 1  
  ask turtle 0 [
                setxy 9 9
                set color blue
                set age random 20
                set affect 0.001 
                set delta 0
                set lambda 1
                set learning_rate .1
                set threshold .5
                set event_count 0
                set disposition 0
                set probability 0
                set memory []
                  repeat memory_length 
                    [set memory lput random-float 0 memory]
                ;set memory [0]                 
                ;set memory [0 0 0 0]
                ;set label who
                ]  

end
  
to setup-patches
  ask patches [set pcolor yellow + random 2]  
end
  
to go
  if ticks >= 50000 [stop]
  move-turtles
  hatch-turtles
  activate-patches
 ; update-event_count
  update-affect
  update-probability
  update-disposition
 ; take-action
  deactivate-patches 
 ; do-plots1
 ; do-plots2
 ; do-plots3
die-turtles
print-memory
migrate-offspring
print ticks
 tick
end

to update-event_count
ask turtles[
    if pcolor = orange + 1 [set event_count event_count + 1]             ]
end

to hatch-turtles
   ask turtles [
      if random 100 < 3 and count turtles < 2
      [ hatch 1 [right random 360
         forward 1]]
   ]
end

to update-affect 
   ask turtles [
        if pcolor = orange + 1 
           [set affect affect + (learning_rate * (affect ^ delta) * (lambda - affect))]    
        if pcolor != orange + 1
           [set affect affect + (learning_rate * (affect ^ delta) * extinction_rate *(0 - affect))] 
               ]
end

to print-memory
  ask turtles[
    print memory ]
  end

to update-probability
 ask turtles[
 let current_probability  (count patches in-radius vision with [pcolor = orange + 1]/(count patches in-radius vision))
 set memory but-first memory                                                   
 set memory lput current_probability memory                                  
 set probability mean memory
 ;set probability median memory                                     
   ]
 end
 
to update-disposition
 ask turtle 0 [
   set disposition affect + probability  - threshold]
end

to move-turtles
  ask turtles [   ; with [who != 0] [
    right random 360
    forward 1
    ]
    end

to migrate-offspring
  if count turtles > 1
   [ask turtle 1
     [facexy -12 -12
       forward 1]]
end
  
to take-action  
  ask turtles [                                            
    if disposition > 0 [ask patches in-radius action_radius [set pcolor red - 3]]
    ]    
end

to die-turtles
  if count turtles = 2 
   [ask turtle 0 [set shape "x"
      set color black 
      set xcor 10
      set ycor 10]
  ]
end

to activate-patches  ; patches in north that are not dead
 ask patches with [ pycor > 0]
      [if random 1000 < attack_rate and pcolor != red - 3 [set pcolor orange + 1]]
end

to deactivate-patches
 ask patches with [ pycor > 0]     
     [if random 100 < 8 and pcolor != red - 3 [set pcolor yellow + random 2]]
end

to do-plots1
    set-current-plot "Disposition"
    set-current-plot-pen "turtle 0"
    plot [disposition] of turtle 0
    set-current-plot-pen "turtle 1"
    plot [disposition] of turtle 1
    set-current-plot-pen "turtle 2"
    plot [disposition] of turtle 2
   end
   
to do-plots2    
    set-current-plot "Probability"
    set-current-plot-pen "turtle 0"
    plot [probability] of turtle 0
    set-current-plot-pen "turtle 1"
    plot [probability] of turtle 1
    set-current-plot-pen "turtle 2"
    plot [probability] of turtle 2
   end

to do-plots3    
    set-current-plot "Affect"
    set-current-plot-pen "turtle 0"
    plot [affect] of turtle 0
    set-current-plot-pen "turtle 1"
    plot [affect] of turtle 1
    set-current-plot-pen "turtle 2"
    plot [affect] of turtle 2
   end
@#$#@#$#@
GRAPHICS-WINDOW
205
10
644
470
16
16
13.0
1
10
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
52
67
115
100
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
53
117
116
150
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

MONITOR
55
365
127
410
NIL
count turtles
17
1
11

PLOT
666
16
897
206
Disposition
trials
Dispositions
0.0
1.0
-0.5
1.0
true
true
"" ""
PENS
"turtle 0" 1.0 0 -10899396 true "" ""
"turtle 1" 1.0 0 -2674135 true "" ""
"turtle 2" 1.0 0 -13345367 true "" ""

SLIDER
8
169
180
202
attack_rate
attack_rate
0
1000
100
1
1
NIL
HORIZONTAL

SLIDER
8
205
180
238
extinction_rate
extinction_rate
0
.5
0
.01
1
NIL
HORIZONTAL

SLIDER
8
238
180
271
vision
vision
1
35
4
1
1
NIL
HORIZONTAL

SLIDER
7
272
179
305
action_radius
action_radius
0
5
1
1
1
NIL
HORIZONTAL

PLOT
664
224
899
432
Probability
trials
probability
0.0
1.0
0.0
1.0
true
true
"" ""
PENS
"turtle 0" 1.0 0 -10899396 true "" ""
"turtle 1" 1.0 0 -2674135 true "" ""
"turtle 2" 1.0 0 -13345367 true "" ""

SLIDER
7
308
179
341
memory_length
memory_length
1
100
10
1
1
NIL
HORIZONTAL

PLOT
665
447
906
652
Affect
trials
affect
0.0
1.0
0.0
1.0
true
true
"" ""
PENS
"turtle 0" 1.0 0 -10899396 true "" ""
"turtle 1" 1.0 0 -2674135 true "" ""
"turtle 2" 1.0 0 -13345367 true "" ""

@#$#@#$#@
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
NetLogo 5.0.5
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

jcurve
1.0
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
