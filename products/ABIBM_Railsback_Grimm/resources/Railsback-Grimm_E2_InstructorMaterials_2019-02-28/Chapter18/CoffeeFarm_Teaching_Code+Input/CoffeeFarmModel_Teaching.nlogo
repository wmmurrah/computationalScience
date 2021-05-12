; This version is to test stochastic variability in CBB dynamics

globals
[
  ; Output file name
  output-file-name
  
  ; Spatial and temporal scale parameters
  space-width   ; The width of the square space, in m
  cell-size     ; The width of each square cell (patch), in m
  cell-area     ; The area of a cell, m2 (calculated from cell-size
  clump-spacing ; The minimum distance among where clumps are started, in m
  simulation-duration ; The number of days simulated
  
  forage-time-step     ; Time step length, hrs
  current-time         ; Current time, hrs since daily foraging started
  
  ; Bird parameters
  initial-bird-density    ; initial density (birds/ha)
  max-forage-hrs-per-day  ; max number of hours of foraging
  forage-radius       ; foraging radius in meters
  daily-min-intake    ; minimum intake to avoid starvation
  
  ; CBB parameters
  CBB-I-initial-high-shade  ; Initial CBB infestation rate in high-shade coffee
  CBB-I-initial-low-shade   ; Initial CBB infestation rate in low-shade coffee
  CBB-I-r-high-shade        ; Infestation growth rate in high-shade coffee 
  CBB-I-r-low-shade         ; Infestation growth rate in low-shade coffee 
  CBB-I-K-high-shade-mean        ; Infestation max rate in high-shade coffee 
  CBB-I-K-high-shade-SD        ; Infestation max rate in high-shade coffee 
  CBB-I-K-low-shade-mean         ; Infestation max rate in low-shade coffee 
  CBB-I-K-low-shade-SD         ; Infestation max rate in low-shade coffee 
  CBB-berry-dens-high-shade ; Coffee berry density (/m2) in high-shade coffee
  CBB-berry-dens-low-shade  ; Coffee berry density (/m2) in low-shade coffee
  CBB-borer-wt              ; Weight of female borer (g)

  ; Parameters for landuse areas
  frac-forest  ; The fraction of the landscape that is forest
  frac-high-shade ; The fraction of the landscape that is predominantly high-shade coffee
  frac-low-shade  ; The fraction of the landscape that is predominantly low-shade coffee
  frac-unusable   ; The fraction of the landscape that is farmland unusable by birds (e.g., pasture)
  frac-trees      ; The fraction of *non-forest area* that is overlain by trees (small forest patches)
  ; frac-other      ; The fraction that is other land uses (e.g., residential) - assumed all other land
  
  ; Parameters for number of landuse clumps
  num-forest-clumps
  num-high-shade-clumps
  num-low-shade-clumps
  num-unusable-clumps
  num-trees-clumps
  
  ; patch sets for landuse types
  forest-patches
  high-shade-patches
  low-shade-patches
  unusable-patches
  trees-patches
  other-patches
  coffee-patches    ; combination of high- and low-shade patches
  
  ; Colors for landuse types
  forest-color
  high-shade-color
  low-shade-color
  unusable-color
  trees-color
  other-color
  
  ; Bug parameters
  forest-bug-prod
  high-shade-bug-prod
  low-shade-bug-prod
  unusable-bug-prod
  trees-bug-prod
  other-bug-prod
  
  forest-bug-catchability
  high-shade-bug-catchability
  low-shade-bug-catchability
  unusable-bug-catchability
  trees-bug-catchability
  other-bug-catchability
  CBB-catchability
  
  ; Output variables for foraging hours
  forage-hrs-forest
  forage-hrs-high-shade
  forage-hrs-low-shade
  forage-hrs-high-shade-CBB
  forage-hrs-low-shade-CBB
  forage-hrs-unusable
  forage-hrs-trees
  forage-hrs-other
  
  ; Output variables for biomass consumed
  mass-eaten-forest
  mass-eaten-high-shade
  mass-eaten-low-shade
  mass-eaten-unusable
  mass-eaten-trees
  mass-eaten-other
  mass-eaten-CBB
  
  CBB-I-high-shade-exclosure
  CBB-I-low-shade-exclosure
  
  ; Virtual survey output variables
  survey-file-name     ; separate output file for bird surveys
  survey-plot-radius   ; radius of survey plot, meters
  survey-frequency     ; days between virtual bird surveys
  is-survey-day?       ; boolean for whether it is a survey day
  survey-num-plots     ; number of survey plots
  survey-spacing       ; minimum distance between plot centers, m
  survey-border-dist   ; maximum distance between plot centers and space border, m
  survey-patches       ; agentset of patches that are survey plot centers
  
  ; Bug irruption variables
  bug-irruption-patches  ; agentset of patches where irruption occurs
  irruption-end-time         ; last tick of irruption
  irruption-file-name    ; name of output file for irruption results
  
  ; Move distance output variables
  time-since-last-loc-obs  ; time (h) since last time bird locations were observed
  observed-move-dists-list   ; a list of distances between location observations - over all birds, all hours
  
]


patches-own
[
  bug-production    ; local copy of land-use-dependent parameter
  bug-catchability  ; local copy of land-use-dependent parameter
  bug-availability  ; total grams bugs available for whole patch
  
  CBB-I             ; Current infestation rate
  CBB-availability       ; g CBB available as prey in patch
  daily-start-CBB-availability  ; CBB before bird consumption; used to calculate bird consumption
  CBB-I-K  ; Now a patch variable
  
  distance-to-trees ; Used for virtual bird survey plots
]

turtles-own
[
  home-patch  ; home patch
  daily-intake ; daily grams food consumed
  daily-hours-foraged       ; number of hours that bird actually foraged
  I-ate-CBB?   ; for tracking what birds eat
  times-ate-CBB-today  ; for tracking how many times CBB were eaten

  ; Move distance output variables
  patch-at-last-obs          ; patch where bird was at last hourly location observation
]


to set-parameters
  
  ; Output file name- 
  set output-file-name (word "CoffeeOutput-LS" landscape-scenario ".csv")
  ; Spatial and temporal scale parameters
  set space-width 1000 ; The width of the square space, in m
  set cell-size  5     ; The width of each square cell (patch), in m
  set cell-area (cell-size * cell-size)
  set clump-spacing 200 ; The minimum distance among clump starts, in m
  set simulation-duration 151 ; The number of days simulated - Dec 1 to Apr 30
  
  set forage-time-step 1 / 60   ; 60 moves per hr
  
  ; Bird parameters
  set initial-bird-density 20    ; Birds / ha
  set max-forage-hrs-per-day 12
  set forage-radius 9        ; Forage only in adjacent patches
  set daily-min-intake 5.0

  ; Parameters for landuse areas
  set frac-forest        0.1
  set frac-high-shade    0.28
  set frac-low-shade     0.28
  set frac-unusable      0.28
  set frac-trees         0.02
  ; set frac-other         0.1
  
  let total-land-types (frac-forest + frac-high-shade + frac-low-shade + frac-unusable)
  
  if total-land-types > 1.001
    [user-message (word "Land use types sum to " total-land-types)]
  
  ; Parameters for number of landuse clumps
  set num-high-shade-clumps   20
  set num-low-shade-clumps    20
  set num-unusable-clumps     10
  set num-trees-clumps      1000
  
  ; Set colors for landuse types
  set forest-color      green
  set high-shade-color  grey
  set low-shade-color   yellow
  set unusable-color    brown
  set trees-color       lime
  set other-color       orange
  
  ; Set bug parameters
  set forest-bug-prod     0.018
  set high-shade-bug-prod 0.016
  set low-shade-bug-prod  0.0054
  set unusable-bug-prod   0.00054
  set trees-bug-prod      0.018
  set other-bug-prod      0.0014

  set forest-bug-catchability      35
  set high-shade-bug-catchability  90
  set low-shade-bug-catchability  170
  set unusable-bug-catchability    35
  set trees-bug-catchability       70
  set other-bug-catchability       35
  set CBB-catchability           1000
  
  ; Set CBB parameters
  set CBB-I-initial-high-shade  0.05  ; Initial CBB infestation rate in high-shade coffee
  set CBB-I-initial-low-shade   0.05  ; Initial CBB infestation rate in low-shade coffee
  set CBB-I-r-high-shade        0.05  ; Infestation growth rate in high-shade coffee 
  set CBB-I-r-low-shade         0.05  ; Infestation growth rate in low-shade coffee 
  set CBB-I-K-high-shade-mean      0.20  ; Mean infestation max rate in high-shade coffee 
  set CBB-I-K-high-shade-SD        0.05  ; SD of infestation max rate in high-shade coffee 
  set CBB-I-K-low-shade-mean       0.40  ; Mean infestation max rate in low-shade coffee 
  set CBB-I-K-low-shade-SD         0.10  ; SD of infestation max rate in low-shade coffee 
  set CBB-berry-dens-high-shade 220   ; Coffee berry density (/m2) in high-shade coffee
  set CBB-berry-dens-low-shade  270   ; Coffee berry density (/m2) in low-shade coffee
  set CBB-borer-wt            0.00049 ; Weight of female borer (g)
  
  ; Virtual survey output variables
  set survey-file-name (word "VirtualSurvey-LS" landscape-scenario ".csv")
  set survey-plot-radius 11.3        ; radius of survey plot, meters
  set survey-frequency 30            ; days between virtual bird surveys
  set survey-num-plots 30            ; number of survey plots
  set survey-spacing 10              ; minimum distance between plot centers, m
  set survey-border-dist 10          ; maximum distance between plot centers and space border, m
  set survey-patches patch-set nobody  ; agentset of patches that are survey plot centers

  ; Bug irruption variables
  set bug-irruption-patches patch-set nobody  ; agentset of patches where irruption occurs

  ; Move distance output variables
  set time-since-last-loc-obs 0.0  ; time (h) since last time bird locations were observed

end


to load-landscape
  
  clear-all
  
  ; set parameter values, in a separate procedure
  set-parameters
  
  ; Temporarily store any globals defined on the interface because "import-world" overwrites them
  ; let temp-initial-bird-density initial-bird-density
  
  ; size the world
  let max-cor ((space-width / cell-size) - 1)
  resize-world 0 max-cor 0 max-cor
  set-patch-size 2.5     ; Controls size of world display
  
  ; Load a landscape file or have user create one
  let landscape-file (word "cbb-landscape-" landscape-scenario ".csv")
  if-else file-exists? landscape-file
  [
    show (word "Loading landscape file " landscape-file)
    import-world landscape-file
  ]
  [
    user-message (word "Please create landscape file for scenario " landscape-scenario)
    stop
  ]
  
  ; And we need to restore any globals defined on the interface because "import-world" overwrites them
  ; set initial-bird-density temp-initial-bird-density 
  
end


to setup
  
  ; Clean up manually -- Cannot clear-all because it would destroy landscape
  ask turtles [die]
  ask patches [set plabel ""]
  reset-ticks
  clear-all-plots
  clear-drawing
  
  ; Now we unfortunately need to set the parameters again because loading the world
  ; un-sets them
  set-parameters
  
  ; Set a new random seed because "import-world" restores an old one
  random-seed new-seed
  
  ; initial agentsets of land use patches
  set forest-patches patches with [pcolor = forest-color]
  set high-shade-patches patches with [pcolor = high-shade-color]
  set low-shade-patches patches with [pcolor = low-shade-color]
  set unusable-patches patches with [pcolor = unusable-color]
  set trees-patches patches with [pcolor = trees-color]
  set other-patches patches with [pcolor = other-color]
  set coffee-patches (patch-set high-shade-patches low-shade-patches)
  
  ; Some defensive programming...make sure we loaded a landscape
  if (count forest-patches) + (count high-shade-patches) + (count low-shade-patches) + (count other-patches) = 0
  [ 
    user-message "You need to load a landscape before running Setup"
    stop
  ]
  
  ; Initialize static patch variables
  ask forest-patches [set bug-production forest-bug-prod]
  ask high-shade-patches [set bug-production high-shade-bug-prod]
  ask low-shade-patches [set bug-production low-shade-bug-prod]
  ask unusable-patches [set bug-production unusable-bug-prod]
  ask trees-patches [set bug-production trees-bug-prod]
  ask other-patches [set bug-production other-bug-prod]
  
  ask forest-patches [set bug-catchability forest-bug-catchability]
  ask high-shade-patches [set bug-catchability high-shade-bug-catchability]
  ask low-shade-patches [set bug-catchability low-shade-bug-catchability]
  ask unusable-patches [set bug-catchability unusable-bug-catchability]
  ask trees-patches [set bug-catchability trees-bug-catchability]
  ask other-patches [set bug-catchability other-bug-catchability]

  ; Initialize CBB rates  
  ask patches [set CBB-availability 0]
  ask high-shade-patches 
  [
    set CBB-I CBB-I-initial-high-shade
    set CBB-I-K random-normal CBB-I-K-high-shade-mean CBB-I-K-high-shade-SD
    if CBB-I-K < CBB-I [set CBB-I-K CBB-I]   ; The max infestation rate can't be less than starting rate
    if CBB-I-K > 1.0 [set CBB-I-K 1.0]
  ]
  ask low-shade-patches 
  [
    set CBB-I CBB-I-initial-low-shade
    set CBB-I-K random-normal CBB-I-K-low-shade-mean CBB-I-K-low-shade-SD
    if CBB-I-K < CBB-I [set CBB-I-K CBB-I]   ; The max infestation rate can't be less than starting rate
    if CBB-I-K > 1.0 [set CBB-I-K 1.0]
  ]
  do-CBB-dynamics

  ; And globals representing exclosures
  set CBB-I-high-shade-exclosure CBB-I-initial-high-shade
  set CBB-I-low-shade-exclosure CBB-I-initial-low-shade
  
  ; And tracking movement distances
  set observed-move-dists-list (list)

  
  ; Initialize birds. "initial-bird-density" is sometimes a slider; birds per ha over the whole space.
  crt initial-bird-density * (count patches * cell-area) / 10000 ; m2 / ha
  [
    set size 2
    move-to one-of patches
    set home-patch patch-here
    
    set patch-at-last-obs patch-here
  ]
  
  ; Open the main output file
  ; Do not delete it instead of appending to it because we could be doing multiple model run experiments
  ; Instead- print headers only if the file is new, and put date and time
  ; as separator between model runs

  ifelse (file-exists? output-file-name) 
  [
    file-open output-file-name
    ; Print a header between model runs
    file-type date-and-time
    file-type (word ",Landscape:," landscape-scenario)
    file-type (word ",Total area:," (count patches * cell-area))
    file-type (word ",Fraction forest:," (count forest-patches / count patches))
    file-type (word ",Fraction high-shade:," (count high-shade-patches / count patches))
    file-type (word ",Fraction low-shade:," (count low-shade-patches / count patches))
    file-type (word ",Fraction unusable:," (count unusable-patches / count patches))
    file-type (word ",Fraction trees:," (count trees-patches / count patches))
    file-print (word ",Fraction other:," (count other-patches / count patches))
  ]
  [
    file-open output-file-name
    file-print date-and-time
    file-type ","
  
    file-type "day,"
    file-type "bird-abundance,"
    file-type "hrs-foraged,"
    file-type "cbb-rate-high-shade,"
    file-type "cbb-rate-low-shade,"
    file-type "cbb-rate-high-shade-exclosure,"
    file-type "cbb-rate-low-shade-exclosure,"
    file-type "bird-density-forest,"
    file-type "bird-density-high-shade,"
    file-type "bird-density-low-shade,"
    file-type "bird-density-high-shade-CBB,"
    file-type "bird-density-low-shade-CBB,"
    file-type "bird-density-unusable,"
    file-type "bird-density-trees,"
    file-type "bird-density-other,"
    file-type "mass-eaten-forest,"
    file-type "mass-eaten-high-shade,"
    file-type "mass-eaten-low-shade,"
    file-type "mass-eaten-unusable,"
    file-type "mass-eaten-trees,"
    file-type "mass-eaten-other,"
    file-type "mass-eaten-CBB,"
    file-print "CBB-cons-events"
  ]
  file-close
  
  initialize-virtual-surveys

end


to go
  
  tick
  if ticks > simulation-duration [stop]
  
  ; First, re-set daily bug availability
  ask patches [set bug-availability (bug-production *  cell-area)]

  ; Second, model CBB infestation and prey density
  do-CBB-dynamics

  ; Third, reset daily variables
  reset-daily-variables
  
  ; Optional test output file -- NOTE file is over-written each time step! It's big
  ;if file-exists? "Forage-Test-Output.csv" [file-delete "Forage-Test-Output.csv"]
  ;file-open "Forage-Test-Output.csv"
  ;file-print "Turtle,time,pxcor,pycor,pcolor,bug-availability,bug-catchability,CBB-availability,CBB-catchability,Intake/h"

  ; Fourth, birds forage repeatedly
  ; Number of moves each day = hrs / (hrs/move) (truncates to integer)
  repeat (max-forage-hrs-per-day / forage-time-step)
  [
    set current-time current-time + forage-time-step
    ask turtles [forage]
    if is-survey-day? [ do-bird-survey ]
    update-irruption
    do-location-surveys
  ]
  
  
  ; Close the optional test output file
  ; file-close
  
  ; Fifth, birds go back home at night.
  ask turtles [move-to home-patch]
  
  ; Sixth, birds die if they could not eat enough
  ask turtles
  [
    if daily-intake < daily-min-intake [if random-float 1.0 < 0.2 [die]] ; 1/5 of starving birds die, to weed out excess
  ]
  
  ; Finally, update outputs
  update-output
  
end


to reset-daily-variables
  
  ; Reset bird foraging variables
    ask turtles 
  [
    set daily-intake 0
    set daily-hours-foraged 0
    set times-ate-CBB-today 0
  ]

  set forage-hrs-forest 0
  set forage-hrs-high-shade 0
  set forage-hrs-low-shade 0
  set forage-hrs-high-shade-CBB 0
  set forage-hrs-low-shade-CBB 0
  set forage-hrs-unusable 0
  set forage-hrs-trees 0
  set forage-hrs-other 0 
  set observed-move-dists-list (list)

  ; Have one turtle trace its path, after erasing previous traces
  ask turtles [pu]
  clear-drawing
  ask one-of turtles 
  [ 
    set color black
    pd 
  ]
  
  ; Determine if it is a bird census day
  ifelse (remainder ticks survey-frequency) = 0 
  [set is-survey-day? true]
  [set is-survey-day? false]

  ; Reset time-of-day counter
  set current-time 0.0
    
end


to forage   ; a turtle procedure for selecting habitat and feeding, repeated within day
  
  if daily-intake > daily-min-intake [stop]
  
  set I-ate-CBB? false
  
  ifelse foraging-theory = "optimal cell - short"
  [
    ; Move to nearby cell with best food intake
    move-to max-one-of patches in-radius (forage-radius / cell-size) [food-intake-rate]
  ]
  [
    ifelse foraging-theory = "random"
    [
      ; Move randomly
      move-to one-of patches in-radius (forage-radius / cell-size)
    ]
    [
      ifelse foraging-theory = "optimal departure"
      [
        ; Move only if intake is too low to meet daily intake
        let intake-here [food-intake-rate] of patch-here
        let needed-intake ((daily-min-intake - daily-intake) / (max-forage-hrs-per-day - current-time)) 
        if intake-here < needed-intake
        [
          move-to one-of neighbors
        ]

      ]
      [
        ifelse foraging-theory = "optimal cell - long"
        [
          ; Move to cell with best food intake in radius 100 m
          move-to max-one-of patches in-radius (100 / cell-size) [food-intake-rate]
        ]
        [ error "Invalid foraging theory" ]
      ]
    ]
  ]
  
  feed
  set daily-hours-foraged (daily-hours-foraged + forage-time-step)
  
  ; Update output variables
  if I-ate-CBB? [ set times-ate-CBB-today times-ate-CBB-today + 1 ]
  if-else pcolor = forest-color [set forage-hrs-forest forage-hrs-forest + forage-time-step]
  [ if-else pcolor = high-shade-color [if-else I-ate-CBB?
                                          [set forage-hrs-high-shade-CBB forage-hrs-high-shade-CBB + forage-time-step]
                                          [set forage-hrs-high-shade forage-hrs-high-shade + forage-time-step] ]
    [ if-else pcolor = low-shade-color [if-else I-ate-CBB?
                                          [set forage-hrs-low-shade-CBB forage-hrs-low-shade-CBB + forage-time-step]
                                          [set forage-hrs-low-shade forage-hrs-low-shade + forage-time-step] ]
      [ if-else pcolor = unusable-color [set forage-hrs-unusable forage-hrs-unusable + forage-time-step]
        [ if-else pcolor = trees-color [set forage-hrs-trees forage-hrs-trees + forage-time-step]
          [ if-else pcolor = other-color [set forage-hrs-other forage-hrs-other + forage-time-step]
              [user-message "Invalid patch type in forage"]
          ]
        ]
      ]
    ]
  ]
  
  
end

to-report food-intake-rate  ; a patch reporter; intake rate in g / hr
                            ; The reporter depends on a valid value of catchability to keep birds from having
                            ; intake higher than the total food available in the patch.
  
  ; Test output
  ; file-type (word [who] of myself "," current-time "," pxcor "," pycor "," pcolor "," bug-availability "," bug-catchability "," CBB-availability "," CBB-catchability)
  if-else CBB-availability <= 0.0 
  [ 
  ;  file-print (word "," ((bug-availability / cell-area) * bug-catchability))
    report  (bug-availability / cell-area) * bug-catchability
  ]
  [
    let bug-intake (bug-availability / cell-area) * bug-catchability
    let CBB-intake (CBB-availability / cell-area) * CBB-catchability
  
    if-else bug-intake > CBB-intake
    [ 
   ;   file-print (word "," bug-intake)
      report bug-intake
    ]
    [ 
   ;   file-print (word "," CBB-intake)
      report CBB-intake
    ]
  ]
  
end


to feed   ; a bird procedure that uses variables of the bird's patch
  
  let intake ([food-intake-rate] of patch-here) * forage-time-step
  set daily-intake (daily-intake + intake)

  let bug-rate bug-availability * bug-catchability  ; Note that "bug-rate" and "CBB-rate" are NOT the intake rate!!
  let CBB-rate CBB-availability * CBB-catchability  ; (cell area is left out to avoid an unnecessary calculation)
  if-else bug-rate > CBB-rate
    [
      set bug-availability (bug-availability - intake)
      if bug-availability < 0 [set bug-availability 0]
    ]
    [
      set I-ate-CBB? true
      set CBB-availability (CBB-availability - intake)
      if CBB-availability < 0 [set CBB-availability 0]
    ]
  
end


to do-CBB-dynamics  ; High and low shade patches use the same methods but different parameters
  
  ask high-shade-patches
  [
    ; First re-calculate yesterday's change in inf. rate to reflect bird consumption
    ; then update the infestation rate
    let dI CBB-availability / (CBB-berry-dens-high-shade * CBB-borer-wt * cell-area)
    set CBB-I CBB-I + dI
    
    ; Second, update infestation rate for logistic increase
    set dI CBB-I-r-high-shade * CBB-I * (1 - (CBB-I / CBB-I-K))
    
    ; Third, update CBB biomass exposed to bird predation
    set CBB-availability dI * CBB-berry-dens-high-shade * CBB-borer-wt * cell-area
    set daily-start-CBB-availability CBB-availability
    
  ]
  
  ask low-shade-patches
  [
    ; First re-calculate yesterday's change in inf. rate to reflect bird consumption
    ; then update the infestation rate
    let dI CBB-availability / (CBB-berry-dens-low-shade * CBB-borer-wt * cell-area)
    set CBB-I CBB-I + dI
    
    ; Second, update infestation rate for logistic increase
    set dI CBB-I-r-low-shade * CBB-I * (1 - (CBB-I / CBB-I-K))
    
    ; Third, update CBB biomass exposed to bird predation
    set CBB-availability dI * CBB-berry-dens-low-shade * CBB-borer-wt * cell-area
    set daily-start-CBB-availability CBB-availability
    
  ]
  
end


to create-landscape
  
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks
    
  ; set parameter values, in a separate procedure
  set-parameters
  
  ; size the world
  let max-cor ((space-width / cell-size) - 1)
  resize-world 0 max-cor 0 max-cor
  set-patch-size 2.5     ; Controls size of world display
  
  random-seed landscape-scenario   ; "scenario" is chosen on interface; provides discrete number of landscapes
  
  show (word "Creating landscape scenario " landscape-scenario)

  create-forest
  
  create-clumps-for frac-unusable num-unusable-clumps unusable-color
  
  create-clumps-for frac-high-shade num-high-shade-clumps high-shade-color
  
  create-clumps-for frac-low-shade num-low-shade-clumps low-shade-color
  
  create-sprinkles-for frac-trees num-trees-clumps trees-color
  
  ; Set remaining patches to "other" color - the default land use
  ask patches with [pcolor = black] [set pcolor other-color]
  
  
  random-seed new-seed
  
end


to create-forest
  
  let num-forest-patches frac-forest * count patches
  
  ; To save time, first create a solid strip of half the forest
  ask patches with [pxcor > (max-pxcor * (1 - (frac-forest / 2)))]  [set pcolor forest-color]
  

  ; Now add patches randomly to the strip to create a ragged edge  
  while [count patches with [pcolor = forest-color] < num-forest-patches]
  
  [
    ; get rid of isolated patches of non-forest
    ask patches with [pcolor != forest-color and count neighbors with [pcolor = forest-color] > 6]
      [ set pcolor forest-color]
      
    ask one-of patches with [pcolor != forest-color and any? neighbors with [pcolor = forest-color] ]
    ; For smoother boundary, replace "any?" with "count neighbors with [pcolor = forest-color] > 1" etc.
    [
      set pcolor forest-color
    ]
    
  ]
  
end


to create-clumps-for [frac-area num-clumps a-color]  ; Observer method to create clumps of a habitat type
  
  let tries 0
  let successes 0
  
  while [tries < 1000]
  [
    let seed-patch one-of patches with [pcolor = black]
    ask seed-patch
    [
      if-else any? patches in-radius (clump-spacing / cell-size) with [pcolor = a-color] 
      [stop]
      [
        set successes successes + 1
        set pcolor a-color
        ; ask neighbors with [pcolor = black] [set pcolor a-color] This makes clump a little rounder
      ]
    ]
    set tries tries + 1
    if successes >= num-clumps [set tries 1000]
    
  ] ; while [tries < 1000]
      
  
  let num-patches-to-use count patches * frac-area
  while [count patches with [pcolor = a-color] < num-patches-to-use]
  [
    let avail-patches patches with [pcolor = a-color and any? neighbors with [pcolor = black]]
    if-else any? avail-patches
    [
      ask one-of avail-patches 
        [
          ask neighbors with [pcolor = black] [set pcolor a-color]
        ]
    ]
    [
      user-message (word "Not enough black patches available for landuse color " a-color)
      stop
    ]
    
  ] ; while [count patches with [pcolor = a-color]
  
end


to create-sprinkles-for [frac-area num-clumps a-color]

  if frac-area <= 0 [stop]  
  
  let mean-size (frac-area * count patches) / num-clumps ; mean area, in patches, of tree sprinkles
  ; show mean-size
  
  repeat num-clumps
  [
    let sprinkle patch-set one-of patches with [pcolor != forest-color and pcolor != a-color]
    ask one-of sprinkle [set pcolor a-color]
    let sprinkle-size round (random-exponential mean-size)
    ; show sprinkle-size
    
    while [count sprinkle < sprinkle-size]
    [
      let a-patch one-of sprinkle with [any? neighbors with [pcolor != forest-color and pcolor != a-color]]
      if-else a-patch = nobody ; patch is isolated in forest so grab another
      [
        set sprinkle patch-set one-of patches with [pcolor != forest-color and pcolor != a-color]
        ask one-of sprinkle [set pcolor a-color]
      ]
      [
        ask a-patch
        [
          ask one-of neighbors with [pcolor != forest-color and pcolor != a-color]
          [
            set pcolor a-color
            set sprinkle (patch-set sprinkle self)
          ]
        ]
      ]
      
    ]
  ]
  
end


to initialize-virtual-surveys
  
  ifelse (file-exists? survey-file-name) 
  [
    file-open survey-file-name
    ; Print a header between model runs
    file-print date-and-time
  ]
  [
    file-open survey-file-name
    file-print date-and-time
    file-type ","
  
    file-type "day,"
    file-type "time,"
    file-type "plot-center-XY,"
    file-type "plot-area,"
    file-type "distance-to-trees,"
    file-print "bird-count"
  ]
 
  file-close
  
  let tries 0
  let successes 0
  let border-dist survey-border-dist / cell-size
  let possible-patches coffee-patches with 
  [
    (pxcor - min-pxcor > border-dist) and 
    (max-pxcor - pxcor > border-dist) and 
    (pycor - min-pycor > border-dist) and 
    (max-pycor - pycor > border-dist)
  ]
  ; show count possible-patches

  while [tries < 1000]
  [
    let seed-patch one-of possible-patches
    ask seed-patch
    [
      if-else any? survey-patches in-radius (survey-spacing / cell-size) 
      [stop]
      [
        set successes successes + 1
        set survey-patches (patch-set survey-patches seed-patch)
        set plabel "S"
      ]
    ]
    set tries tries + 1
    if successes >= survey-num-plots [set tries 1000]
  ]
  
  ; Now calculate the distance to forest or trees
  let forest+tree-patches (patch-set forest-patches trees-patches)
  ask survey-patches
  [
    set distance-to-trees cell-size * (distance min-one-of forest+tree-patches [distance myself])
  ]
  

end


to do-bird-survey
  
  file-open survey-file-name
  
  ask survey-patches
  [
    file-type "," ; Blank column for separator between runs
    file-type (word ticks ",")
    file-type (word current-time ",")
    file-type (word pxcor "x" pycor ",")
    file-type (word ((count patches in-radius (survey-plot-radius / cell-size)) * cell-area) ",")
    file-type (word distance-to-trees ",")
    file-print count turtles-on (patches in-radius survey-plot-radius)
  ]
 
  file-close
  
end


to start-irruption   ; a patch procedure for bug irruptions, executed from an Agent Monitor
  
  ; First, you can't start one irruption if another is under way (messes up output)
  if count bug-irruption-patches > 0
  [
    user-message "An irruption is already underway; you cannot start another now"
    stop
  ]
  
  set bug-irruption-patches patches in-radius (25 / cell-size)  ; irruptions occur over 25-m radius
  ask bug-irruption-patches [set plabel "I"]
  
  set irruption-end-time (ticks + 30)   ; irruptions last 10 days, preceded and followed by 10 days of output.
  
  set irruption-file-name (word "BugIrruptionAtTick" ticks ".csv")
  
  file-open irruption-file-name  ; File is always appended, with new header line
  file-print (word date-and-time "," "Coordinates of irruption center:" "," pxcor "," pycor)
  file-type ","
  
  file-type "day,"
  file-type "time,"
  file-type "bug production,"
  file-type "irruption-area,"
  file-print "bird-count"
 
  file-close
  
end


to update-irruption   ; an observer procedure to execute bug irruptions, once they are started
  
  ; Stop if there is no irruption
  if count bug-irruption-patches = 0 [stop]
  
  
  ; First see if it's time to increase bug production - 10 days after start
  if (irruption-end-time - ticks = 20) and (current-time <= forage-time-step)
  [
    ask bug-irruption-patches [set bug-production (bug-production * 5)]  ; irruptions increase bugs x 5
  ]

  ; Next see if it's time to reset bug production - 20 days after start
  if (irruption-end-time - ticks = 10) and (current-time <= forage-time-step)
  [
    ask bug-irruption-patches [set bug-production (bug-production / 5)]  ; irruptions increase bugs x 5
  ]

  ; Then, see if it's over
  if ticks >= irruption-end-time
  [
    ask bug-irruption-patches [set plabel ""]
    set bug-irruption-patches patch-set nobody
    stop
  ] 
  
  
  file-open irruption-file-name  ; File is always appended, with new header line
  file-type ","
  
  file-type (word ticks ",")
  file-type (word current-time ",")
  file-type (word (mean [bug-production] of bug-irruption-patches) ",")
  file-type (word (count bug-irruption-patches * cell-area) ",")
  file-print count turtles-on bug-irruption-patches
 
  file-close
  
end


to do-location-surveys     ; observer procedure to observe bird locations and movement distances hourly
  
  ifelse time-since-last-loc-obs < 1.0
  [
    set time-since-last-loc-obs time-since-last-loc-obs + forage-time-step
  ]
  [
    set time-since-last-loc-obs forage-time-step  ; re-set the timer
    ask turtles with [daily-intake < daily-min-intake]
    [ 
      set observed-move-dists-list fput (cell-size * distance patch-at-last-obs) observed-move-dists-list
      set patch-at-last-obs patch-here 
    ]
  ]

  
end


to update-output
  ;
  ; First calculate outputs
  ;
  ; Bird densities by habitat type
  let bird-density-forest         (forage-hrs-forest / max-forage-hrs-per-day) / (count forest-patches * cell-area / 10000)
  let bird-density-high-shade     (forage-hrs-high-shade / max-forage-hrs-per-day) / (count high-shade-patches * cell-area / 10000)
  let bird-density-low-shade      (forage-hrs-low-shade / max-forage-hrs-per-day) / (count low-shade-patches * cell-area / 10000)
  let bird-density-high-shade-CBB (forage-hrs-high-shade-CBB / max-forage-hrs-per-day) / (count high-shade-patches * cell-area / 10000)
  let bird-density-low-shade-CBB  (forage-hrs-low-shade-CBB / max-forage-hrs-per-day) / (count low-shade-patches * cell-area / 10000)
  let bird-density-unusable       (forage-hrs-unusable / max-forage-hrs-per-day) / (count unusable-patches * cell-area / 10000)
  let bird-density-trees          (forage-hrs-trees / max-forage-hrs-per-day) / (count trees-patches * cell-area / 10000)
  let bird-density-other          (forage-hrs-other / max-forage-hrs-per-day) / (count other-patches * cell-area / 10000)
  
  ; Calculate daily food consumption by habitat type
  set mass-eaten-forest 0
  set mass-eaten-high-shade 0
  set mass-eaten-low-shade 0
  set mass-eaten-unusable 0
  set mass-eaten-trees 0
  set mass-eaten-other 0
  set mass-eaten-CBB 0
  
  ; First some defensive programming
  ask patches
  [
    if (bug-production < 0.0) or (bug-availability < 0.0) or (bug-production * cell-area < bug-availability)
    [
      user-message (word "Bug production error at patch " pxcor " " pycor 
        " Production: " bug-production " Availability: " bug-availability)
    ]
  ]  ; ask patches
  
  ask coffee-patches
  [
    if (daily-start-CBB-availability < 0.0) or (CBB-availability < 0.0) or (daily-start-CBB-availability < CBB-availability)
    [
      user-message (word "CBB production error at patch " pxcor " " pycor 
        " Starting avail: " daily-start-CBB-availability " Ending avail: " CBB-availability)
    ]
  ]  ; ask coffee-patches
    
  ; Each patch increases total consumption by the difference between its production and
  ; the biomass left at the end of the day
  ask forest-patches [set mass-eaten-forest (mass-eaten-forest + (bug-production * cell-area) - bug-availability)]
  ask high-shade-patches [set mass-eaten-high-shade (mass-eaten-high-shade + (bug-production * cell-area) - bug-availability)]
  ask low-shade-patches [set mass-eaten-low-shade (mass-eaten-low-shade + (bug-production * cell-area) - bug-availability)]
  ask unusable-patches [set mass-eaten-unusable (mass-eaten-unusable + (bug-production * cell-area) - bug-availability)]
  ask trees-patches [set mass-eaten-trees (mass-eaten-trees + (bug-production * cell-area) - bug-availability)]
  ask other-patches [set mass-eaten-other (mass-eaten-other + (bug-production * cell-area) - bug-availability)]
  ask high-shade-patches [set mass-eaten-CBB (mass-eaten-CBB + daily-start-CBB-availability - CBB-availability)]
  ask low-shade-patches [set mass-eaten-CBB (mass-eaten-CBB + daily-start-CBB-availability - CBB-availability)]
  
  ; Calculate CBB infestation rates for exclosures (rates with no bird consumption)
  let dI CBB-I-r-high-shade * CBB-I-high-shade-exclosure * (1 - (CBB-I-high-shade-exclosure / CBB-I-K-high-shade-mean))
  set CBB-I-high-shade-exclosure (CBB-I-high-shade-exclosure + dI)
  set dI CBB-I-r-low-shade * CBB-I-low-shade-exclosure * (1 - (CBB-I-low-shade-exclosure / CBB-I-K-low-shade-mean))
  set CBB-I-low-shade-exclosure (CBB-I-low-shade-exclosure + dI)
  
  ;
  ; Now write file output
  ;
  file-open output-file-name
  file-type "," ; Blank column for separator between runs
  file-type (word ticks ",")
  file-type (word (count turtles) ",")
  file-type (word (mean [daily-hours-foraged] of turtles) ",")
  file-type (word (mean [CBB-I] of high-shade-patches) ",")
  file-type (word (mean [CBB-I] of low-shade-patches) ",")
  file-type (word CBB-I-high-shade-exclosure ",")
  file-type (word CBB-I-low-shade-exclosure ",")

  file-type (word bird-density-forest ",")
  file-type (word bird-density-high-shade ",")
  file-type (word bird-density-low-shade ",")
  file-type (word bird-density-high-shade-CBB ",")
  file-type (word bird-density-low-shade-CBB ",")
  file-type (word bird-density-unusable ",")
  file-type (word bird-density-trees ",")
  file-type (word bird-density-other ",")

  file-type (word mass-eaten-forest ",")
  file-type (word mass-eaten-high-shade ",")
  file-type (word mass-eaten-low-shade ",")
  file-type (word mass-eaten-unusable ",")
  file-type (word mass-eaten-trees ",")
  file-type (word mass-eaten-other ",")
  file-type (word mass-eaten-CBB ",")
  file-print sum [ times-ate-CBB-today ] of turtles
  file-close

  ;
  ; Plot outputs
  ;
  set-current-plot "Foraging hours histogram"
  histogram [daily-hours-foraged] of turtles
  
  ; Plot foraging densities: birds / day / ha
  set-current-plot "Bird density"
  
  set-current-plot-pen "Forest"
  plot bird-density-forest

  set-current-plot-pen "High shade"
  plot bird-density-high-shade

  set-current-plot-pen "Low shade"
  plot bird-density-low-shade

  set-current-plot-pen "High shade CBB"
  plot bird-density-high-shade-CBB

  set-current-plot-pen "Low shade CBB"
  plot bird-density-low-shade-CBB

  set-current-plot-pen "Unusable"
  plot bird-density-unusable

  set-current-plot-pen "Trees"
  plot bird-density-trees

  set-current-plot-pen "Other"
  plot bird-density-other
  
  ; Plot CBB availability
  set-current-plot "CBB availability"
  histogram [CBB-availability] of coffee-patches
  
  ; Plot daily food consumption by habitat type
  set-current-plot "Bug consumption"
  set-current-plot-pen "Forest"
  plot mass-eaten-forest

  set-current-plot-pen "High shade"
  plot mass-eaten-high-shade

  set-current-plot-pen "Low shade"
  plot mass-eaten-low-shade

  set-current-plot-pen "Unusable"
  plot mass-eaten-unusable

  set-current-plot-pen "Trees"
  plot mass-eaten-trees

  set-current-plot-pen "Other"
  plot mass-eaten-other

  set-current-plot-pen "CBB"
  plot mass-eaten-CBB
  
  ; Update histogram of movement distances
  set-current-plot "Hourly move distance histogram"
  histogram observed-move-dists-list


end
@#$#@#$#@
GRAPHICS-WINDOW
479
10
989
541
-1
-1
2.5
1
10
1
1
1
0
0
0
1
0
199
0
199
0
0
1
ticks
30.0

CHOOSER
21
102
159
147
landscape-scenario
landscape-scenario
1 2 3 4 5
0

BUTTON
98
10
161
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
10
150
190
183
create and save landscape
if file-exists? (word \"cbb-landscape-\" landscape-scenario \".csv\")\n [ user-message (word \"Replace landscape scenario \" landscape-scenario \"?\")]\ncreate-landscape\nexport-world (word \"cbb-landscape-\" landscape-scenario \".csv\")
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
172
10
235
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
172
46
235
79
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
273
10
473
160
Foraging hours histogram
Hours foraged
Number of birds
0.0
12.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" ""

PLOT
5
377
271
551
Bird density
Day
Birds / ha
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Forest" 1.0 0 -10899396 true "" ""
"High shade" 1.0 0 -7500403 true "" ""
"Low shade" 1.0 0 -1184463 true "" ""
"Unusable" 1.0 0 -6459832 true "" ""
"Trees" 1.0 0 -13840069 true "" ""
"Other" 1.0 0 -955883 true "" ""
"High shade CBB" 1.0 0 -2674135 true "" ""
"Low shade CBB" 1.0 0 -13345367 true "" ""

PLOT
274
167
474
317
CBB availability
Day
Total CBB available (g)
0.0
0.02
0.0
10.0
true
false
"" ""
PENS
"default" 5.0E-4 1 -16777216 false "" ""

PLOT
6
192
271
373
Bug consumption
Day
Bug biomass eaten
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Forest" 1.0 0 -10899396 true "" ""
"High shade" 1.0 0 -7500403 true "" ""
"Low shade" 1.0 0 -1184463 true "" ""
"Unusable" 1.0 0 -6459832 true "" ""
"Trees" 1.0 0 -13840069 true "" ""
"Other" 1.0 0 -955883 true "" ""
"CBB" 1.0 0 -2674135 true "" ""

BUTTON
14
10
77
43
load
load-landscape
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
275
321
475
490
Hourly move distance histogram
NIL
NIL
0.0
400.0
0.0
2000.0
true
false
"" ""
PENS
"default" 10.0 1 -16777216 false "" ""

CHOOSER
15
50
164
95
foraging-theory
foraging-theory
"random" "optimal departure" "optimal cell - short" "optimal cell - long"
2

MONITOR
172
102
262
147
Foraging hour
current-time
2
1
11

@#$#@#$#@
# Jamaica Coffee Farm Model 

## Background

This is the model described by Railsback & Johnson 2011, adapted as a teaching model by S. Railsback, October 2015. The model and NetLogo code are copyrighted 2015 by Steven F. Railsback.

> Railsback, S. F. and M. D. Johnson. 2011. Pattern-oriented modeling of bird foraging and pest control in coffee farms. Ecological Modelling 222:3305-3319.

See the instructional materials distributed with this NetLogo file for information on its design and purpose.

These materials are distributed to support teaching based on:

> Railsback, S. F. and V. Grimm. 2012. Agent-based and individual-based modeling: a practical introduction. Princeton University Press, Princeton, New Jersey.

For more information see: 
http://www.railsback-grimm-abm-book.com
https://qubeshub.org/groups/abm

## Software use

  * The code is set up to reproduce the baseline simulations of Railsback & Johnson 2011. (It will not reproduce them exactly.)

  * To start a simulation, first hit "load" to import a saved landscape file (discussed further below). The landscape loaded is determined by the chooser "landscape-scenario". Then hit "setup", and then "go". Subsequent runs with the same landscape can be executed by hitting setup and go again.

  * The chooser "foraging theory" lets the user select one of the four foraging theories described by Railsback & Johnson 2011. This choice can be made at any time.

  * Each model run produces an output file named "CoffeeOutput-LS#.csv" where "#" is the landscape number chosen on the interface. If not deleted by the user between runs, this file is **appended to** each model run--this makes the output file useful for BehaviorSpace experiments. The output file reports many different results for each simulated day.

  * A second output file is named "VirtualSurvey-LS#.csv". It reports the results of the virtual surveys described by Railsback & Johnson 2011. This file is also appended, not overwritten, each model run.

  * For quicker runs, reduce the number of simulation days. In the procedure "set-parameters" set simulation-duration to something like 50 days. (Little changes after the initial 30-50 days.)

  * Setting "View updates" to "on ticks" instead of "continuous" speeds up execution considerably but does not allow observation of bird foraging.

  * To create new landscape scenarios:

    * Use the "landscape-scenario" chooser to select the landscape number you want to replace or create. You can edit the chooser to add more landscape numbers (currently there are five).
    * Edit the landscape parameters, in the "set parameters" procedure. For example, to make all the coffee habitat sun (low-shade) instead of high-shade, change frac-high-shade to 0.0 and frac-low-shade to 0.56.
    * Hit the button "create and save landscape". It takes several minutes to generate the landscape. To see it happen (highly recommended), set "View updates" to "continuous". The landscape is saved in a file named something like "cbb-landscape-1.csv".


  * One of the patterns discussed by Railsback & Johnson 2011 is a "bug irruption", an outbreak of insect food in a small area. Bug irruptions can be started manually on any patch: right-click on the patch, select "inspect patch". In the command line of the inspector, simply enter the command "start-irruption" (no quotes), which executes the patch procedure that initializes a bug irruption. The irruption then lasts for 30 days (10 baseline, 10 of high food, 10 baseline) and produces its own output file.
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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="5 landscapes, 1 replicate" repetitions="1" runMetricsEveryStep="false">
    <setup>load-landscape
setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <metric>; Outputs are not important here because you can use the model's</metric>
    <metric>; output file.</metric>
    <enumeratedValueSet variable="landscape-scenario">
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
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
