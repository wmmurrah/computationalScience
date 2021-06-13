;; This research funded by The Engineering and Physical Sciences Research Council (EPSRC),
;;;; Grant GR/S79299/01 (AIBACS),
;;;; ``The Impact of Durative Variable state on the Design and Control of Action Selection''.
;;;   Code written originally by Jing Jing Wang at university of Bath (Wang 2003).
;;;   Corrected & extended by Hagen Lehmann for Lehman, Wang & Bryson (2005) and Bryson, Ando & Lehman (2007).
;;;   Updated again in 2008 for NetLogo 4, with some simplifications from original code.
;;;   All work conducted at the University of Bath, United Kingdom.
;;;;;;;;;;;;
;;;;;;;;;;;; current version of the code is reviewed and corrected by Ellen Evers at The University of Utrecht, Netherlands.
;;;;;;;;;;;; corrections at lines 22 and 80 [fleeD, chaseD], 226 ["wiggle-angle" while fleeing], 251 [search angle]

;;;  version updated to run with NetLogo 4.1 on 5 March 2011 by Joanna Bryson
;;;  version updated to run with NetLogo 6.1 on 4 October 2029 by Joanna Bryson (Hertie School)

;;;;;;;;;;;;;;;; globale Variablen ;;;;;;;;;;;;;;;

globals[

   PerSpace        ;personal space
   NearView        ;close view
   MaxView         ;far view
   time-units      ;monitor to show the number of  goes
   male-ints            ;monitor to show the number of times of male interaction carried on
   female-ints          ;monitor to show the number of times of female interaction carried on
   aggmale         ;aggressive interactions by males
   aggfemale       ;aggressive inteactions by females
   vision-angle    ;in what direction the turtle can see
   search-angle    ;where the turtle searches for other agents

   ;;;;; EE: define chaseD and fleeD as global variables (is much safer and more logical, as these values never change or differ)
   chaseD	   ;winner's chasing distance
   fleeD           ;loser's fleeing distance

   min-dom         ;minimal dominance value
   randomrunnum    ;crappy hack to get unique filenames for each run in behaviourspace experiments
   filename        ;place for aforementioned filename
]


;;;;;;;;;;;;;;;;;; breeds ;;;;;;;;;;;;;;;;;;;;;;;;;

breed [ males male ]
breed [ females female ]



;;;;;;;;;;;;;;; monkey variablen ;;;;;;;;;;;;;;;;;;;

turtles-own [

    attraction           ;sexual attraction
    StepDom              ;intensity of aggression
    dom-value            ;hierarchy variablen
    w                    ;win variable
    diff                 ;the actual vision angle between two agents
    opponent             ;direkter Gegner
    distanceP            ;the distance zu Gegner
    waitcount            ;waiting position counter
    ]



;;;;;;;;;;;;;;; setup-procedure ;;;;;;;;;;;;;;;;;;;

to setup

  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks                     ;clear the screen

  setup-globals
  setup-patches
  setup-turtles
;  setup-file  ; uncomment to save data
end



;;;;;;;;;;;;;;;; creates background ;;;;;;;;;;;;;;

to setup-patches
   ask patches  [set pcolor green]    ;sets background green
end

to setup-globals
               set PerSpace 2
               set NearView 24
               set MaxView  50

	       ;; EE: set values of global variables
	       set chaseD 1
       	 set fleeD  2

	       set vision-angle 120
               set search-angle  90
               set min-dom 0.1
               set randomrunnum random 999999

end


;;;;;;;;;;;;;;;; creates male and female monkeys ;;;;;;;;;;;;;;;;;;

to setup-turtles
 create-males population
     [set color black
      set dom-value 16.0]
 create-females population
     [set color red
      set dom-value 8.0]
  ask turtles [set heading random 360
               set shape "arrow"
               setxy ((random (30 + 0.0)) - (30 / 2)) ((random (30 + 0.0)) - (30 / 2))
                 ]
end

;;;;;;;;;;;;;;;  initialize the data file (only used if you are doing analysis, for dominance & centrality) ;;;;;;;;;;

to setup-file

  set filename (word "ReplicationDomWorld" intensity-of-aggression  attraction?  randomrunnum ".csv")
  file-open filename
  file-print (word "intensity of aggresion:" intensity-of-aggression)
  file-print (word "population: " population)
  file-print (word "attraction: " attraction?)
end

;;;;;;;;;;;;;;;;; vision ;;;;;;;;;;;;;;;;;;;

to-report substract-headings [h1 h2]
    ifelse abs (h1 - h2) <= 180
    [ report h1 - h2 ]
    [ ifelse h1 > h2
    [ report h1 - h2 - 360 ]
    [ report h1 - h2 + 360 ] ]
end

;;;;;;;;;;;;;;;;;;;;;; reports vision variables ;;;;;;;;;;;;;;;;;;;;;;

To-report away [ agent ]
    report  ( 180 + towards agent )
end

to-report seen-by-myself? [ agent ]
    report (abs (subtract-headings ([towards agent] of myself) ([heading] of myself))) <= (([vision-angle] of myself) / 2)
end

to-report other-turtles
   report turtles with [self != myself]
end

to-report visible-turtles [ViewSight angle]
    report other-turtles in-radius ViewSight with [seen-by-myself? self]
end

to-report visible-females [ViewSight angle]
    report other-turtles in-radius ViewSight with [seen-by-myself? self and breed = females]
end


to-report nearest [agentset]
  report min-one-of agentset [distance myself]          ;;find nearest agent in a group

end


;;;;;;;;;;;;;;;;;;;;;; interaction procedure ;;;;;;;;;;;;;;;;;;;;;;;;

to interact
   let winner 0
  let loser 0
  let mentalV 0
  let yyy 0



       set opponent (nearest visible-turtles PerSpace vision-angle)     ;opponent always exists because of conditional in integrate function
       set heading towards opponent
       if distance opponent <= PerSpace
          [
	  ; increment interactions
	  if (breed = males)   [set male-ints male-ints + 1]
    if (breed = females) [ set female-ints female-ints + 1]
	              set mentalV ([dom-value] of self)/([dom-value] of self + [dom-value] of opponent)
                ifelse (mentalV > random-float 1.00)
                   [
                     set winner self
                     set loser opponent
                     ]
                   [
                     set winner opponent
                     set loser self
                     ]
	  	          if (winner = self)  [ fight ]
    ]

end
;;;;;;;;;;;;;;;;;;;;;;;; fighting ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to fight
  let winner 0
  let loser 0
  let relativeV 0
  let yyy 0



	; increment aggressive interaction
	if (breed = males) and ([breed] of opponent = females) [set aggmale aggmale + 1]
  if (breed = females) and ([breed] of opponent = males) [ set aggfemale aggfemale + 1]
  set relativeV ([dom-value] of self)/([dom-value] of self + [dom-value] of opponent)
  ifelse (relativeV > random-float 1.00)  [
    set w 1
    set winner self
    set loser opponent
  ]
  [
    set w 0
    set winner opponent
    set loser self
  ]

            ; intensity of aggression is set by a slider, so might change between interactions. Maybe this should be moved to setup turtles procedure for efficiency.
            if breed = males [set StepDom 1 * intensity-of-aggression
                             set male-ints male-ints + 1]
            if breed = females [set StepDom 0.8 * intensity-of-aggression
                                set female-ints female-ints + 1]


            set dom-value ([dom-value] of self)+(w - relativeV) * StepDom
            ask opponent [set dom-value ([dom-value] of self)-(w - relativeV) * StepDom]
            ask loser [set dom-value max (list min-dom [dom-value] of self )]            ;;ensure dominance values of agents are above 0.01

            ask winner [set heading towards loser fd chaseD]                        ;; the winner moves one unit towards its opponent, loser makes a 180 degree turn

            ;; EE: changed "set heading away winner + random 45", which results in right-biased fleeing to: random angle that could range from -45 to +45
            ask loser [set heading away winner - 45 + random 90 fd fleeD]               ;; and flees away two untis under a small random angle 45 degree

            ;reduce waitcount for turtles that have seen this interaction in their NearSpace

            ask turtles in-radius NearView [ if (myself != winner) [if (seen-by-myself? winner) [ set waitcount waitcount - 1]]]

end

;;;;;;;;;;;;;;;;;;;;;;;;;;; grouping procedure ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to group
    ifelse any? visible-turtles NearView vision-angle
           [ifelse attraction? [
                                ifelse (breed = males)
                                      [if (any? visible-females NearView vision-angle)
                                      [set heading towards nearest visible-females NearView vision-angle fd 1]]
                                      [ fd 1 ]]
                               [
                                fd 1 ]
                               ]
           [ifelse any? visible-turtles MaxView vision-angle
                   [set heading towards nearest visible-turtles MaxView vision-angle
                    fd 1]

                   ;; EE: changed "rt search-angle / 2 lt search-angle" (which in fact equals "lt search-angle / 2") to "rt search-angle"
                   [ifelse (random-float 1.0) > 0.5 [rt search-angle fd 1]                 ;; if agent does not perceive other agents within MaxView
                                                    [lt search-angle fd 1]                 ;; it turns a Search angle at random to the right or left
                   ]
           ]

end


;;;;;;;;;;;;;;;;; integration procedure ;;;;;;;;;;;;;;;;;;;;;;;

to integrate
      ifelse any? visible-turtles PerSpace vision-angle
                                    [interact]
                                    [group]
end


;;;;;;;;;;;;;;;; go procedure ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go

    ask turtles [
                 ifelse (waitcount <= 0)
                   [integrate
                   set waitcount random 10]
                 [set waitcount waitcount - 1]

                 ]

      set time-units time-units + 1
      if remainder time-units 160 = 0
        [
          do-plot1 do-plot2
 ;         print-data ; uncomment for data file
        ]
      if time-units >= 42800
        [
;          file-close          ; uncomment for data file
          stop
        ]
end


to print-data
let mytime time-units / 160

file-type (word mytime  ", ")
    ask females
      [

        file-type precision [dom-value] of self 3
        file-type ", "
      ]
    ask males
      [

        file-type precision [dom-value] of self 3
        file-type ", "
      ]

file-type (word differentiation ", ")

file-type (word aggfemale ",")

file-print " "

end

;;;;;;;;;; report centrality ;;;;;;;;;;;;

;; we do vector addition of unit vectors by
    ; having a child turtle
    ; move one step in the direction of each other turtle (from the parent),
    ; report its distance from the parent, then
    ; die.

to report-centrality
  let vectors 0


  ask turtles [
    set vectors [towards myself] of other-turtles
    hatch 1 [ measure-vectors vectors report-distance die ]
    ]
end

; recursive function -- go 1 in each direction until none left
to measure-vectors [vectors]
   if (vectors != [])                      ;if finished list, all done
     [ set heading (first vectors)         ;otherwise, go 1 in direction of first element in list
       forward 1
       measure-vectors (butfirst vectors)  ;then do this to the rest of the elements
     ]
end

; write it to the file, associate with parent's ID
to report-distance
  ask myself [file-type precision distance myself 3 file-type ", "]
end

;;;;;;;;;;;;;;;;;;;;;; plots ;;;;;;;;;;;;;;;;;;;;;

to do-plot1
   set-current-plot "Males\\Females"
   set-current-plot-pen "males"
   plot report-boys
   set-current-plot-pen "females"
   plot report-girls

end

to-report differentiation
  let mean-dom-value 0
  let sd-dom-value 0

   set mean-dom-value mean [dom-value] of turtles
   set sd-dom-value standard-deviation [dom-value] of turtles
   report precision (sd-dom-value / mean-dom-value) 3
end

to-report report-boys
   report precision mean [ dom-value ] of males 3
end

to-report report-girls
   report precision mean [ dom-value ] of females 3
end

to-report girls-beating-boys
let total-beat-boys 0
  let girl-power 0


set total-beat-boys 0

; note horrible hack to get list from agent set -- found in netlogo mailing list JJB
foreach ([self] of females) [ ?1 ->
  set girl-power [dom-value] of ?1
  foreach ([self] of males) [ ??1 ->
    if ( [dom-value] of ??1  <  girl-power)
      [ set total-beat-boys total-beat-boys + 1 ]
    ] ]
report total-beat-boys
end

to do-plot2
   set-current-plot "differentiation of dominance"
   plot differentiation
end
@#$#@#$#@
GRAPHICS-WINDOW
437
10
1247
821
-1
-1
2.0
1
4
1
1
1
0
1
1
1
-200
200
-200
200
0
0
1
ticks
30.0

BUTTON
35
28
102
61
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
137
27
200
60
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
17
161
95
206
NIL
time-units
0
1
11

SWITCH
252
28
372
61
attraction?
attraction?
1
1
-1000

PLOT
221
117
421
267
differentiation of dominance
time unit
CV of dom-value
0.0
280.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

PLOT
221
273
421
423
Males\Females
time unit
dom-value
0.0
280.0
0.0
20.0
true
false
"" ""
PENS
"males" 1.0 0 -13345367 true "" ""
"females" 1.0 0 -2064490 true "" ""

SLIDER
17
114
189
147
population
population
0
15
4.0
1
1
NIL
HORIZONTAL

MONITOR
30
360
87
405
NIL
male-ints
3
1
11

MONITOR
123
357
180
402
NIL
female-ints
3
1
11

TEXTBOX
34
260
124
309
overall interactions
11
0.0
0

SLIDER
17
71
214
104
intensity-of-aggression
intensity-of-aggression
0.1
1
1.0
0.1
1
NIL
HORIZONTAL

MONITOR
25
439
95
484
NIL
aggmale
3
1
11

MONITOR
115
438
196
483
NIL
aggfemale
3
1
11

MONITOR
248
445
372
490
girls beating boys
girls-beating-boys
1
1
11

@#$#@#$#@
## WHAT IS IT?

This is a replication of Hemelrijk's DomWorld.  It was written by Hagen Lehmann based on an earlier, less-complete replication by Jing Jing Wang.  It is particularly replicating Hemelrijk's 2002 model of apparent sexual favors extended to females when they are fertile.  This model is slightly modified from one published in 2007, among other things it runs in NetLogo 4.X  (see below).

## HOW IT WORKS

Hemelrijk's theory is that different social structures (e.g. despotic and egalitarian) are a consequence of the level of violence expressed when agents fight.  The apparent favoritism showed to females when they are fertile is actually just a consequence of the fact males are attracted to them, so they get in more fights, so some of them wind up being higher ranking.

## HOW TO USE IT

To run a single experiment, push the Setup button first, then push Go.

To change the conditions of your experiment, you can do the following.

Change the violence level by changing "intensity of aggression".  Hemelrijk uses a value of 1 for despotic species, and .1 for egalitarian ones.

Change whether males are attracted to females by turning the "attraction" switch on or off.

Change the number of individuals in the troop by changing "population".  This is really only half the population -- if you choose 4 (like we did for the paper below) then you will have 4 males and 4 females.

## THINGS TO NOTICE

Please see the papers listed below.

"girls beating boys" is a bit of a misleading name -- it is really the sum over all females of the number of males that each female outranks, so this number may be a lot larger than the total number of males.  For example, if there were four males and four females and all the females outranked all the males, this number would be 16.

## HOW TO GET THE RESULTS IN OUR PAPER

There are two different ways of obtaining data from the model. In the model code itself
are commented lines which need to be uncommented in order to save the data into a file. The lines are clearly marked ("uncomment to save data"). After having done this, the model will produce a data file (.csv). The file will in the first three lines contain information about the experimental setup and 11 data columns. The first column contains the number of measurement points. The 2nd - 5th column represent the dominance value for each of the females for each measurement point. The 6th - 9th column represent the dominance values for the male agents. The 10th column is the domiance variation coefficient and the 11th column represents the number of female initiated dominance interactions. These are the variables we used to analyse the simulation.

In case the user wants to be more flexible about the variables she wants to measure and has experience with NetLogo, there is a second way to extract the data from the model. NetLogo has an inbuild data recording tool. It is called BehaviorSpace and can be found under "Tools". Please see the Netlogo User Manual for a good explanation how it works.

## ANALYSIS

Our analysis showed this is not a very good model of primate social behavior.  First, females only became more dominant some of the time they were attractive, and then because they fought more, and they stayed dominant after they were no longer attractive.  In real primates, females are subject to *less* aggression when they are fertile, and return to their original rank immediately afterwards.

This "original rank" is another large problem with this model.  In most primate species, a female's rank is determined entirely by her mother's rank and her own birth order. On very rare occassions an entire matrilinial line will change order, but this is really an exceptional event.  This may be a better model of species like chimpanzees, but for macaques (a widely-used model genus for studying primate social order) it is not realistic.

## RELATED MODELS

The DomWorld model was originally called MIRROR, and created under the direction of Hemelrijk's PhD supervisor, Paulien Hogeweg, who used it to study bee social organisation.

Yasushi Ando also created a replication of Hemelrijk which is featured in our 2007 paper, it is written in SmallTalk, not NetLogo.  See http://www.cs.bath.ac.uk/~jjb/web/primates/DomWorld.html for a copy.

Hagen Lehmann also has his own models of primate social organisation, most of which are in NetLogo.  See his web page http://www.cs.bath.ac.uk/hl/ under "publications".

Ellen Evers is working on new primate models.  See her web page http://www.bio.uu.nl/behaviour/Evers/main.html

Joanna Bryson has other models of primate behavior, see http://www.cs.bath.ac.uk/~jjb/web/primates/primate-learning.html


## CREDITS AND REFERENCES

This code was started by JingJing Wang at Bath for her MSc in 2003.  Hagen Lehmann also of Bath improved the model in 2005, and then adopted it for NetLogo 4 in 2007.  Ellen Evers of Utrecht checked the code and found & corrected some minor errors in 2008.  These errors didn't affect the gross DomWorld dynamics.  See code for details.

This research was funded by The Engineering and Physical Sciences Research Council (EPSRC), Grant GR/S79299/01 (AIBACS); JJ Bryson PI (Bath).

The analysis was helped greatly by a research visit funded by the British Council Alliance: Franco-British Partnership Programme , ``Origins of Egalitarianism: Improving our understanding primate society through modelling two organizational norms for various species of Macaque'', with Bernard Thierry, Centre d'Ecologie, Physiologie & Ethologie).

Our papers below are available from http://www.cs.bath.ac.uk/~jjb/web/primates/DomWorld.html

Joanna J. Bryson, Yasushi Ando and Hagen Lehmann ``Agent-based modelling as scientific method: a case study analysing primate social behaviour'', Philosophical Transactions of the Royal Society, B -- Biology, 362(1485):1685-1698, September 2007.

Hagen Lehmann, JingJing Wang and Joanna J. Bryson, ``Tolerance and Sexual Attraction in Despotic Societies: A Replication and Analysis of Hemelrijk (2002)'', in Modelling Natural Action Selection: Proceedings of an International Workshop, J. J. Bryson, T. J. Prescott and A. K. Seth, eds., pp. 135-142, AISB, Sussex UK, 2005.

Hemelrijk, C. K. 2002a Despotic societies, sexual attraction and the emergence of male `tolerance': an agent-based model. Behaviour 139, 729-747

Hogeweg, P. & Hesper, B. 1983 The ontogeny of the interaction structure in bumble bee colonies: a MIRROR model. Behav. Ecol. Sociobiol. 12, 271-283.



## LICENSE

This is free, open-source software distributed under the terms of the MIT License, http://www.opensource.org/licenses/mit-license.php

Copyright (c) 2007 Hagen Lehmann

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

ant
true
0
Polygon -7500403 true true 136 61 129 46 144 30 119 45 124 60 114 82 97 37 132 10 93 36 111 84 127 105 172 105 189 84 208 35 171 11 202 35 204 37 186 82 177 60 180 44 159 32 170 44 165 60
Polygon -7500403 true true 150 95 135 103 139 117 125 149 137 180 135 196 150 204 166 195 161 180 174 150 158 116 164 102
Polygon -7500403 true true 149 186 128 197 114 232 134 270 149 282 166 270 185 232 171 195 149 186
Polygon -7500403 true true 225 66 230 107 159 122 161 127 234 111 236 106
Polygon -7500403 true true 78 58 99 116 139 123 137 128 95 119
Polygon -7500403 true true 48 103 90 147 129 147 130 151 86 151
Polygon -7500403 true true 65 224 92 171 134 160 135 164 95 175
Polygon -7500403 true true 235 222 210 170 163 162 161 166 208 174
Polygon -7500403 true true 249 107 211 147 168 147 168 150 213 150

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bee
true
0
Polygon -1184463 true false 151 152 137 77 105 67 89 67 66 74 48 85 36 100 24 116 14 134 0 151 15 167 22 182 40 206 58 220 82 226 105 226 134 222
Polygon -16777216 true false 151 150 149 128 149 114 155 98 178 80 197 80 217 81 233 95 242 117 246 141 247 151 245 177 234 195 218 207 206 211 184 211 161 204 151 189 148 171
Polygon -7500403 true true 246 151 241 119 240 96 250 81 261 78 275 87 282 103 277 115 287 121 299 150 286 180 277 189 283 197 281 210 270 222 256 222 243 212 242 192
Polygon -16777216 true false 115 70 129 74 128 223 114 224
Polygon -16777216 true false 89 67 74 71 74 224 89 225 89 67
Polygon -16777216 true false 43 91 31 106 31 195 45 211
Line -1 false 200 144 213 70
Line -1 false 213 70 213 45
Line -1 false 214 45 203 26
Line -1 false 204 26 185 22
Line -1 false 185 22 170 25
Line -1 false 169 26 159 37
Line -1 false 159 37 156 55
Line -1 false 157 55 199 143
Line -1 false 200 141 162 227
Line -1 false 162 227 163 241
Line -1 false 163 241 171 249
Line -1 false 171 249 190 254
Line -1 false 192 253 203 248
Line -1 false 205 249 218 235
Line -1 false 218 235 200 144

bird1
false
0
Polygon -7500403 true true 2 6 2 39 270 298 297 298 299 271 187 160 279 75 276 22 100 67 31 0

bird2
false
0
Polygon -7500403 true true 2 4 33 4 298 270 298 298 272 298 155 184 117 289 61 295 61 105 0 43

boat1
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

boat2
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 157 54 175 79 174 96 185 102 178 112 194 124 196 131 190 139 192 146 211 151 216 154 157 154
Polygon -7500403 true true 150 74 146 91 139 99 143 114 141 123 137 126 131 129 132 139 142 136 126 142 119 147 148 147

boat3
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 37 172 45 188 59 202 79 217 109 220 130 218 147 204 156 158 156 161 142 170 123 170 102 169 88 165 62
Polygon -7500403 true true 149 66 142 78 139 96 141 111 146 139 148 147 110 147 113 131 118 106 126 71

box
true
0
Polygon -7500403 true true 45 255 255 255 255 45 45 45

butterfly1
true
0
Polygon -16777216 true false 151 76 138 91 138 284 150 296 162 286 162 91
Polygon -7500403 true true 164 106 184 79 205 61 236 48 259 53 279 86 287 119 289 158 278 177 256 182 164 181
Polygon -7500403 true true 136 110 119 82 110 71 85 61 59 48 36 56 17 88 6 115 2 147 15 178 134 178
Polygon -7500403 true true 46 181 28 227 50 255 77 273 112 283 135 274 135 180
Polygon -7500403 true true 165 185 254 184 272 224 255 251 236 267 191 283 164 276
Line -7500403 true 167 47 159 82
Line -7500403 true 136 47 145 81
Circle -7500403 true true 165 45 8
Circle -7500403 true true 134 45 6
Circle -7500403 true true 133 44 7
Circle -7500403 true true 133 43 8

circle
false
0
Circle -7500403 true true 35 35 230

person
false
0
Circle -7500403 true true 155 20 63
Rectangle -7500403 true true 158 79 217 164
Polygon -7500403 true true 158 81 110 129 131 143 158 109 165 110
Polygon -7500403 true true 216 83 267 123 248 143 215 107
Polygon -7500403 true true 167 163 145 234 183 234 183 163
Polygon -7500403 true true 195 163 195 233 227 233 206 159

sheep
false
15
Rectangle -1 true true 90 75 270 225
Circle -1 true true 15 75 150
Rectangle -16777216 true false 81 225 134 286
Rectangle -16777216 true false 180 225 238 285
Circle -16777216 true false 1 88 92

spacecraft
true
0
Polygon -7500403 true true 150 0 180 135 255 255 225 240 150 180 75 240 45 255 120 135

thin-arrow
true
0
Polygon -7500403 true true 150 0 0 150 120 150 120 293 180 293 180 150 300 150

truck-down
false
0
Polygon -7500403 true true 225 30 225 270 120 270 105 210 60 180 45 30 105 60 105 30
Polygon -8630108 true false 195 75 195 120 240 120 240 75
Polygon -8630108 true false 195 225 195 180 240 180 240 225

truck-left
false
0
Polygon -7500403 true true 120 135 225 135 225 210 75 210 75 165 105 165
Polygon -8630108 true false 90 210 105 225 120 210
Polygon -8630108 true false 180 210 195 225 210 210

truck-right
false
0
Polygon -7500403 true true 180 135 75 135 75 210 225 210 225 165 195 165
Polygon -8630108 true false 210 210 195 225 180 210
Polygon -8630108 true false 120 210 105 225 90 210

turtle
true
0
Polygon -7500403 true true 138 75 162 75 165 105 225 105 225 142 195 135 195 187 225 195 225 225 195 217 195 202 105 202 105 217 75 225 75 195 105 187 105 135 75 142 75 105 135 105

wolf
false
0
Rectangle -7500403 true true 15 105 105 165
Rectangle -7500403 true true 45 90 105 105
Polygon -7500403 true true 60 90 83 44 104 90
Polygon -16777216 true false 67 90 82 59 97 89
Rectangle -1 true false 48 93 59 105
Rectangle -16777216 true false 51 96 55 101
Rectangle -16777216 true false 0 121 15 135
Rectangle -16777216 true false 15 136 60 151
Polygon -1 true false 15 136 23 149 31 136
Polygon -1 true false 30 151 37 136 43 151
Rectangle -7500403 true true 105 120 263 195
Rectangle -7500403 true true 108 195 259 201
Rectangle -7500403 true true 114 201 252 210
Rectangle -7500403 true true 120 210 243 214
Rectangle -7500403 true true 115 114 255 120
Rectangle -7500403 true true 128 108 248 114
Rectangle -7500403 true true 150 105 225 108
Rectangle -7500403 true true 132 214 155 270
Rectangle -7500403 true true 110 260 132 270
Rectangle -7500403 true true 210 214 232 270
Rectangle -7500403 true true 189 260 210 270
Line -7500403 true 263 127 281 155
Line -7500403 true 281 155 281 192

wolf-left
false
3
Polygon -6459832 true true 117 97 91 74 66 74 60 85 36 85 38 92 44 97 62 97 81 117 84 134 92 147 109 152 136 144 174 144 174 103 143 103 134 97
Polygon -6459832 true true 87 80 79 55 76 79
Polygon -6459832 true true 81 75 70 58 73 82
Polygon -6459832 true true 99 131 76 152 76 163 96 182 104 182 109 173 102 167 99 173 87 159 104 140
Polygon -6459832 true true 107 138 107 186 98 190 99 196 112 196 115 190
Polygon -6459832 true true 116 140 114 189 105 137
Rectangle -6459832 true true 109 150 114 192
Rectangle -6459832 true true 111 143 116 191
Polygon -6459832 true true 168 106 184 98 205 98 218 115 218 137 186 164 196 176 195 194 178 195 178 183 188 183 169 164 173 144
Polygon -6459832 true true 207 140 200 163 206 175 207 192 193 189 192 177 198 176 185 150
Polygon -6459832 true true 214 134 203 168 192 148
Polygon -6459832 true true 204 151 203 176 193 148
Polygon -6459832 true true 207 103 221 98 236 101 243 115 243 128 256 142 239 143 233 133 225 115 214 114

wolf-right
false
3
Polygon -6459832 true true 170 127 200 93 231 93 237 103 262 103 261 113 253 119 231 119 215 143 213 160 208 173 189 187 169 190 154 190 126 180 106 171 72 171 73 126 122 126 144 123 159 123
Polygon -6459832 true true 201 99 214 69 215 99
Polygon -6459832 true true 207 98 223 71 220 101
Polygon -6459832 true true 184 172 189 234 203 238 203 246 187 247 180 239 171 180
Polygon -6459832 true true 197 174 204 220 218 224 219 234 201 232 195 225 179 179
Polygon -6459832 true true 78 167 95 187 95 208 79 220 92 234 98 235 100 249 81 246 76 241 61 212 65 195 52 170 45 150 44 128 55 121 69 121 81 135
Polygon -6459832 true true 48 143 58 141
Polygon -6459832 true true 46 136 68 137
Polygon -6459832 true true 45 129 35 142 37 159 53 192 47 210 62 238 80 237
Line -16777216 false 74 237 59 213
Line -16777216 false 59 213 59 212
Line -16777216 false 58 211 67 192
Polygon -6459832 true true 38 138 66 149
Polygon -6459832 true true 46 128 33 120 21 118 11 123 3 138 5 160 13 178 9 192 0 199 20 196 25 179 24 161 25 148 45 140
Polygon -6459832 true true 67 122 96 126 63 144
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="end-reps" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>repeat 160 [go]</go>
    <final>print-final-report</final>
    <timeLimit steps="42801"/>
    <metric>report-boys</metric>
    <metric>report-girls</metric>
    <metric>differenciation</metric>
    <metric>girls-beating-boys</metric>
    <enumeratedValueSet variable="attraction?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="intensity-of-aggression">
      <value value="0.1"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

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
