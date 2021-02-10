; NetLogo code by Mayfield Reynolds    07/13/2012
; Based on Drug Dosage module by the Drs. Shiflet

to setup
  ca
  system-dynamics-setup
  set-current-plot "Aspirin"
  set-plot-x-range 0 aStopAt
  set-plot-y-range 0 round a_plasma_conc
  set-current-plot "Dilantin"
  set-plot-x-range 0 dStopAt
end

to go
  if (ticks >= max list aStopAt dStopAt) [stop]
  system-dynamics-go
  update-plots
end

to-report pulse
  if (precision ticks 2 mod interval = start) [ 
    report absorption_fraction * dosage / dt
  ] report 0
end
@#$#@#$#@
GRAPHICS-WINDOW
122
231
367
416
0
0
154.0
1
10
1
1
1
0
1
1
1
0
0
0
0
0
0
1
ticks
30.0

PLOT
32
204
341
435
Aspirin
Time (hours)
Aspirin concentration (µg/mL)
0.0
8.0
0.0
220.0
false
false
"" ""
PENS
"a_plasma_conc" 1.0 0 -16777216 true "" "if (d_volume > 0) [ plotxy ticks a_plasma_conc ]"

BUTTON
382
20
445
53
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

BUTTON
299
20
363
53
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

INPUTBOX
525
57
579
117
dStopAt
168
1
0
Number

MONITOR
145
125
296
170
Aspirin concentration (µg/mL)
a_plasma_conc
2
1
11

TEXTBOX
128
24
278
42
Aspirin Model
14
0.0
1

INPUTBOX
57
118
130
178
#_of_aspirins
2
1
0
Number

TEXTBOX
508
30
658
48
Dilantin Model
14
0.0
1

PLOT
411
205
719
436
Dilantin
Time (hours)
Dilantin concentration (µg/mL)
0.0
10.0
0.0
20.0
false
true
"" ""
PENS
"d_conc" 1.0 0 -16777216 true "" "if (d_volume > 0) [ plotxy ticks d_conc ]"
"MEC" 1.0 0 -11085214 true "" "plotxy ticks MEC"
"MTC" 1.0 0 -2674135 true "" "plotxy ticks MTC"

MONITOR
469
127
642
172
Dilantin conentration (µg/mL)
d_conc
2
1
11

INPUTBOX
139
51
192
111
aStopAt
10
1
0
Number

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

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
NetLogo 5.0.1
@#$#@#$#@
@#$#@#$#@
0.01 
    org.nlogo.sdm.gui.AggregateDrawing 36 
        org.nlogo.sdm.gui.StockFigure "attributes" "attributes" 1 "FillColor" "Color" 225 225 182 105 91 60 40 
            org.nlogo.sdm.gui.WrappedStock "aspirin_in_plasma" "#_of_aspirins * 325 * 1000" 1   
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 139 194 50 50 
            org.nlogo.sdm.gui.WrappedConverter "aspirin_in_plasma / a_plasma_vol" "a_plasma_conc"   
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 215 265 50 50 
            org.nlogo.sdm.gui.WrappedConverter "3000" "a_plasma_vol"   
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 305 169 50 50 
            org.nlogo.sdm.gui.WrappedConverter "((- log e .5) / a_half_life)" "a_elim_constant"   
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 399 143 50 50 
            org.nlogo.sdm.gui.WrappedConverter "3.2" "a_half_life"   
        org.nlogo.sdm.gui.RateConnection 3 177 111 354 111 531 111 NULL NULL 0 0 0 
            org.jhotdraw.standard.ChopBoxConnector REF 1  
            org.jhotdraw.figures.ChopEllipseConnector 
                org.nlogo.sdm.gui.ReservoirFigure "attributes" "attributes" 1 "FillColor" "Color" 192 192 192 530 96 30 30   
            org.nlogo.sdm.gui.WrappedRate "a_elim_constant * aspirin_in_plasma" "a_elimination" REF 2 
                org.nlogo.sdm.gui.WrappedReservoir  0   REF 14 
        org.nlogo.sdm.gui.BindingConnection 2 335 174 354 111 NULL NULL 0 0 0 
            org.jhotdraw.contrib.ChopDiamondConnector REF 7  
            org.nlogo.sdm.gui.ChopRateConnector REF 11   
        org.nlogo.sdm.gui.BindingConnection 2 177 111 354 111 NULL NULL 0 0 0 
            org.jhotdraw.standard.ChopBoxConnector REF 1  
            org.nlogo.sdm.gui.ChopRateConnector REF 11   
        org.nlogo.sdm.gui.BindingConnection 2 143 143 158 199 NULL NULL 0 0 0 
            org.jhotdraw.standard.ChopBoxConnector REF 1  
            org.jhotdraw.contrib.ChopDiamondConnector REF 3   
        org.nlogo.sdm.gui.BindingConnection 2 227 277 176 231 NULL NULL 0 0 0 
            org.jhotdraw.contrib.ChopDiamondConnector REF 5  
            org.jhotdraw.contrib.ChopDiamondConnector REF 3   
        org.nlogo.sdm.gui.BindingConnection 2 404 173 349 188 NULL NULL 0 0 0 
            org.jhotdraw.contrib.ChopDiamondConnector REF 9  
            org.jhotdraw.contrib.ChopDiamondConnector REF 7   
        org.nlogo.sdm.gui.StockFigure "attributes" "attributes" 1 "FillColor" "Color" 225 225 182 257 458 60 40 
            org.nlogo.sdm.gui.WrappedStock "drug_in_system" "0" 1   
        org.nlogo.sdm.gui.ReservoirFigure "attributes" "attributes" 1 "FillColor" "Color" 192 192 192 25 463 30 30  
        org.nlogo.sdm.gui.RateConnection 3 55 478 150 478 245 478 NULL NULL 0 0 0 
            org.jhotdraw.figures.ChopEllipseConnector REF 34  
            org.jhotdraw.standard.ChopBoxConnector REF 32  
            org.nlogo.sdm.gui.WrappedRate "pulse" "entering" 
                org.nlogo.sdm.gui.WrappedReservoir  REF 33 0   
        org.nlogo.sdm.gui.RateConnection 3 329 478 434 478 540 478 NULL NULL 0 0 0 
            org.jhotdraw.standard.ChopBoxConnector REF 32  
            org.jhotdraw.figures.ChopEllipseConnector 
                org.nlogo.sdm.gui.ReservoirFigure "attributes" "attributes" 1 "FillColor" "Color" 192 192 192 539 463 30 30   
            org.nlogo.sdm.gui.WrappedRate "d_elim_constant * drug_in_system" "d_elimination" REF 33 
                org.nlogo.sdm.gui.WrappedReservoir  0   REF 43 
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 19 574 50 50 
            org.nlogo.sdm.gui.WrappedConverter "100 * 1000" "dosage"   
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 76 579 50 50 
            org.nlogo.sdm.gui.WrappedConverter "0" "start"   
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 125 608 50 50 
            org.nlogo.sdm.gui.WrappedConverter "8" "interval"   
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 189 618 50 50 
            org.nlogo.sdm.gui.WrappedConverter ".12" "absorption_fraction"   
        org.nlogo.sdm.gui.BindingConnection 2 207 624 150 478 NULL NULL 0 0 0 
            org.jhotdraw.contrib.ChopDiamondConnector REF 52  
            org.nlogo.sdm.gui.ChopRateConnector REF 35   
        org.nlogo.sdm.gui.BindingConnection 2 150 608 150 478 NULL NULL 0 0 0 
            org.jhotdraw.contrib.ChopDiamondConnector REF 50  
            org.nlogo.sdm.gui.ChopRateConnector REF 35   
        org.nlogo.sdm.gui.BindingConnection 2 108 586 150 478 NULL NULL 0 0 0 
            org.jhotdraw.contrib.ChopDiamondConnector REF 48  
            org.nlogo.sdm.gui.ChopRateConnector REF 35   
        org.nlogo.sdm.gui.BindingConnection 2 55 585 150 478 NULL NULL 0 0 0 
            org.jhotdraw.contrib.ChopDiamondConnector REF 46  
            org.nlogo.sdm.gui.ChopRateConnector REF 35   
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 288 570 50 50 
            org.nlogo.sdm.gui.WrappedConverter "drug_in_system / d_volume" "d_conc"   
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 367 631 50 50 
            org.nlogo.sdm.gui.WrappedConverter "2000" "d_volume"   
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 431 535 50 50 
            org.nlogo.sdm.gui.WrappedConverter "((- log e .5) / d_half_life)" "d_elim_constant"   
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 522 498 50 50 
            org.nlogo.sdm.gui.WrappedConverter "22" "d_half_life"   
        org.nlogo.sdm.gui.BindingConnection 2 529 530 473 552 NULL NULL 0 0 0 
            org.jhotdraw.contrib.ChopDiamondConnector REF 72  
            org.jhotdraw.contrib.ChopDiamondConnector REF 70   
        org.nlogo.sdm.gui.BindingConnection 2 450 540 434 478 NULL NULL 0 0 0 
            org.jhotdraw.contrib.ChopDiamondConnector REF 70  
            org.nlogo.sdm.gui.ChopRateConnector REF 40   
        org.nlogo.sdm.gui.BindingConnection 2 329 478 434 478 NULL NULL 0 0 0 
            org.jhotdraw.standard.ChopBoxConnector REF 32  
            org.nlogo.sdm.gui.ChopRateConnector REF 40   
        org.nlogo.sdm.gui.BindingConnection 2 294 510 308 574 NULL NULL 0 0 0 
            org.jhotdraw.standard.ChopBoxConnector REF 32  
            org.jhotdraw.contrib.ChopDiamondConnector REF 66   
        org.nlogo.sdm.gui.BindingConnection 2 377 645 327 605 NULL NULL 0 0 0 
            org.jhotdraw.contrib.ChopDiamondConnector REF 68  
            org.jhotdraw.contrib.ChopDiamondConnector REF 66   
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 238 381 50 50 
            org.nlogo.sdm.gui.WrappedConverter "10" "MEC"   
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 130 188 183 301 382 50 50 
            org.nlogo.sdm.gui.WrappedConverter "20" "MTC"
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
