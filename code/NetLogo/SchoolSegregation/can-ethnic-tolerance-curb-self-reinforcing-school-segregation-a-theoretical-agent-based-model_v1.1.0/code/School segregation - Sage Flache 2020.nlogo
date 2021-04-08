;##############################################################################################################################################
globals
[
  x0-current                                 ;; stores the value of x0 of the agent called (either intolerant or tolerant)
  m-current                                  ;; stores the value of M of the agent called (either intolerant or tolerant)
  dissimilarity-index                        ;; residential dissimilarity index (Massey & Denton 1998) by ethnicity
  dissimilarity-index-tolerance              ;; residential dissimilarity index (Massey & Denton 1998) by tolerance
  no-double-click                            ;; used to prevent the user from clicking twice on setup2
  available-colors                           ;; list of colors for the schools, used to create the original voronoi diagram
  max-distance                               ;; maximum distance between cells on the map
  #parents                                   ;; number of agents that are parents (not schools)
  #parentsT                                  ;; number of tolerant parents
  #parentsINT                                ;; number of intolerant parents
  max-number-kids                            ;; maximum number of pupils (modelled as links) a school can have
  school-utility                             ;; average ethnic satisfaction V in paper of all parents
  school-utilityT                            ;; average ethnic satisfaction V in paper of tolerant parents
  school-utilityINT                          ;; average ethnic satisfaction V in paper of intolerant parents
  dissimilarity-index-school                 ;; school dissimilarity index (Massey & Denton 1998) by ethnicity
  dissimilarity-index-tolerance-school       ;; school dissimilarity index (Massey & Denton 1998) by tolerance
  list-dissimilarity-index-tolerance-school  ;; list that stores the evolution of school dissimilarity index by tolerance over a simulation run
  list-dissimilarity-index-school            ;; list that stores the evolution of school dissimilarity index by ethnicity over a simulation run
  ID                                         ;; stores the seed of the run
]
;##############################################################################################################################################

;##############################################################################################################################################
turtles-own
[
  parent?                                    ;; boolean: the turtle is either a parent (true) or a school (false)
  index-of-dissimilarity-tolS                ;; for schools, to compute the school dissimilarity index by tolerance
  index-of-dissimilarityS                    ;; for schools, to compute the school dissimilarity index by ethnicity
  list-school                                ;; for schools, a list that stores the ethnic satisfaction (V in the paper) for each type of agent (4 values: 2 ethnic groups * 2 levels of tolerance)
  residents                                  ;; for schools, an agenset of parents that attend to the school (equivalent to link-neighbors but used to check if there have been changes in the parents between iteration)
  group-parent                               ;; stores the type of the parent: 0= intol green; 1= intol blue; 2= tol green; 3=tol blue
  satisfaction-of-school                     ;; ethnic component of the utility of a school for a parent (V in the paper)
  tolerance                                  ;; boolean: the turtle is either tolerant (true) or intolerant (false)
  identity                                   ;; variable that take the value of the color of the agent
]
;##############################################################################################################################################

;##############################################################################################################################################
patches-own
[
  patch-id                                   ;; unique identifier for each patch
  dissi-patch                                ;; to compute the dissimilarity index: divide the grid of patches into N groups (see equation 5 paper)
  empty-patch                                ;; boolean, the patch is empty (true), or has an agent on it (false)
  turtles-around                             ;; agent-set of parents in the radius of the patch
  list-empty-patch                           ;; list that contains the 4 satisfaction's (V in paper) values that the different types of agent would get if they would move to the patch for (residential model)
 ]
;##############################################################################################################################################





;                                                                   ######
;                                                               ##############
;                                                          ########################
;                                                      ################################
;                                                  ########################################
;                                             ######### SCHELLING RESIDENTIAL MODEL ############
;                                                  ########################################
;                                                      ################################
;                                                          ########################
;                                                               ##############
;                                                                   ######





;##############################################################################################################################################
to setup ;;for the schelling-type residential model

  reset-ticks
  clear-all
  set no-double-click 0 ; impossible to click twice on setup2, i.e. the procedure that initialize the school model (creates the schools and assigns parents to the nearest school)
  set ID random 9999999
  random-seed ID ; ID can be stored in the output files in behavior space for replication of same runs

  ask patches ; give a unique identifier (patch-id) to all patches
  [
    sprout 1
    set patch-id [who] of turtles-here
  ]
  clear-turtles

  let size-world count patches
  let #-parents (size-world * (1 - %-empty-patches))
  ask n-of #-parents patches
  [
    sprout 1
    [
      set color 45
      set shape  "square"
      let t random 100
      if t <= %-tolerant-agents [ set tolerance true ]
      if t > %-tolerant-agents [ set tolerance false ]
      ; first define whether agents are tolerant or not and then we change their ethnicity
      if tolerance = true [ set shape "circle" ]
    ]
  ]
  ask n-of (#-parents * %-group2) turtles [ set color 107 ]


  ask turtles
  [ ;create parents with a given tolerance type and a given ethnicity
    set identity [color] of self
    if (tolerance = false)
    [
      ifelse (identity =  45) [set color 44] [ set color 105]
    ]
    set parent? true
  ]

  ;parents set var "group-parent" -> dep on tolerance and ethnicity
  ask turtles
  [
    if color = 44 [set group-parent 0]  ; intol green
    if color = 105 [set group-parent 1] ; intol blue
    if color = 45 [set group-parent 2]  ; tol green
    if color = 107 [set group-parent 3] ; tol blue
  ]

  ; set global variables
   set #parents count turtles
   set #parentsT count turtles with [tolerance = TRUE ]
   set #parentsINT count turtles with [tolerance = FALSE ]

  ; DISSIMILARITY INDEX
  ; Forces the user to set the right dimensions
  ; to the map so that the dissi indices can be computed
  ;; Only work if the location of origin is "corner" (top left of the lattice) which means that
  ;; ycor of the first line is 0, ycor of the line under it is -1 etc.
  let h max-pxcor
  set h abs h
  set h h + 1
  ;because the first patch has a xcor of 0
  ifelse h mod 5 != 0 [ show " The width of the map must be dividable by 5 " ] [
  let b min-pycor
  set b abs b
  set b b + 1
  ifelse b mod 5 != 0
    [ show " The lenght of the map must be dividable by 5 " ] ;; writes an error messsage if the size of the world is not dividable by 5 which is a necessary
                                                              ;; condition to compute the dissimilarity indices
    [
      ;procedure that creates groups of squares of 25 patches, stores the result in the patch-variable dissi-patch
      set max-distance sqrt ((h ^ 2) + (b ^ 2)) / 2
      let break-box 0
      let break-boxes 0
      let break-line 0
      let break-lines 0
      let col 1
      while [ abs break-line < b ]
      ;; keeps going on as long as it has not reached the end the last line (b=number of lines)
      [
        while [ break-box <  h ]
        ;; keeps going on as long as it has not reached the last column of the ligne (h=number of columns)
        [
          ask patch break-box break-line [ set dissi-patch break-lines * 100 + break-boxes ]
          set break-box break-box + 1
          if ( ( break-box ) mod 5 = 0 ) [ set break-boxes ( break-box ) / 5 ]
          ;;assign the same color to the five first patches, and then another color to the next five patches etc.
        ]
        set break-box 0
        set break-boxes 0
        set break-line break-line - 1
        if ( break-line mod 5 = 0 ) [ set break-lines break-lines + 1 ]
      ];; squares of 5x5 patches have the same dissi-patch


  ; First patches define if they are empty or not
  ; Second, if they are empty, then they compute all the values of satisfaction
  ; they would provide to each group of agents and store it in list-empty-patch
      ask patches
      [
        let t count turtles-here
        ifelse t = 1  [ set empty-patch false ] [ set empty-patch true ] ; each patch defines if it is empty or not initially
        let count-g1 0
        let count-g2 0
        set list-empty-patch [] ; list-empty-patch is going to have 4 values: each corresponding to the ethnic satisfaction (V in paper) that each type of parent (combination of 2 ethnicity * 2 levels of tolerance) would get if they would move to the patch
        if empty-patch = true
        [
          set turtles-around (turtles-on (patches in-radius radiusNeighborhood)) ;AF ; "turtles-around" is an agentset that is kept in patches memories
          ifelse count turtles-around > 0
          [
            set count-g1 count turtles-around with [identity = 45]
            set count-g2 count turtles-around with [identity = 107]
            set x0-current x0-intolerant
            set m-current M-intolerant
            let elem1 V count-g1 count-g2
            set elem1 exp (beta * elem1)
            set list-empty-patch lput elem1 list-empty-patch
            let elem2 V count-g2 count-g1
            set elem2 exp (beta * elem2)
            set list-empty-patch lput elem2 list-empty-patch
            set x0-current x0
            set m-current M
            let elem3 V count-g1 count-g2
            set elem3 exp (beta * elem3)
            set list-empty-patch lput elem3 list-empty-patch
            let elem4 V count-g2 count-g1
            set elem4 exp (beta * elem4)
            set list-empty-patch lput elem4 list-empty-patch
          ]
          [ set list-empty-patch [1 1 1 1] ]; in the case where the patch is not empty: give fictious values to the list-empty-patch
        ];end of if empty-patch = true
      ];end of ask patches
      update-globals
      reset-ticks
    ]
  ]
end
;##############################################################################################################################################


;##############################################################################################################################################
to go ; schelling residential model, one iteration

  move-turtles
  if update-globals-during-run
  [
    if ticks mod update-globals-every = 0
    [ update-globals ]
  ]
  tick

  end
;##############################################################################################################################################


;##############################################################################################################################################
to move-turtles

  ask  n-of number-agents-selected turtles ; selects x agents at random that will take a residential decision (choose to move or stay) at this iteration
  [
    let possible-destinations no-patches
    ifelse no-tolerant-residentialM = false
    [ ; no-tolerant-residentialM = false -> meaning that intolerant and tolerant parents behave differently in the residential model
      ask patch-here [ patch-update ] ; the patch where the agent is currently located updates, i.e. it computes the values of ethnic satisfactions all types of agents would receive if they would move here (in this case if they would stay)
      set possible-destinations n-of number-of-destinations patches with [ empty-patch = true ] ; selects at random other empty patches that become potential destination for the agent
      ask possible-destinations ; these potential destinations also update but only if there has been some change in the surrounding turtles since the last time they updated
      [
        let turtles-around-t+1 ( turtles-on ( patches in-radius radiusNeighborhood ) )
        if  turtles-around-t+1 !=  turtles-around
        [ patch-update ] ; if there are different turtles around than the last time the patch was updated -> updates satisfactions V for agents
      ]
      set possible-destinations ( patch-set patch-here possible-destinations ) ; add the current patch to possible-destinations
      ask possible-destinations [ set empty-patch true ] ; all possible-destinations set empty-patch to true and only destination tha will be selected will set empty-patch to false
                                                         ; each patch part of possible-destinations has updated its satisfaction V values in its own list "list-empty-patch"
      let i [group-parent] of self
      let list-utilities []
      let list-patch-id []
      ask possible-destinations
      [
        let t item i list-empty-patch ; each possi-desti takes the utility value in its list-empty-patch that corresponds to the group of the parent
        set list-utilities lput t list-utilities ; puts it in "list-utilities" (there is only one for each parent)
        let l patch-id
        set list-patch-id lput l list-patch-id ; and puts at the same time in "list-patch-id" its patch identity
                                               ; so that the two list are aligned
      ]
      let tot-uti sum list-utilities
      set list-utilities map [ j -> j / tot-uti ] list-utilities ; list-utilities contains the probabilities of moving to each possible destination according to equation 4 in paper, and sum of list-utilities = 1
      let selected-destination random-weighted list-patch-id list-utilities ;draws one value of the list with patch-id's with probabilities taken from the list-utilities
      move-to one-of patches with [ patch-id = selected-destination ] ; then move to the destination (remember that it can be the patch where the turtle was already because it had been added to the possible-destinations before)
      ask one-of patches with [ patch-id = selected-destination ] [ set empty-patch FALSE ] ; ask the selected destination to set empty-patch -> FALSE
    ]

    [ ; case where the tolerance has no importance: all parents behave as if they were intolerant
      ask patch-here [ patch-update ]
      set possible-destinations n-of number-of-destinations patches with [ empty-patch = true ]
      ask possible-destinations
      [
        let turtles-around-t+1 (turtles-on (patches in-radius radiusNeighborhood)) ;;new AF
        if  turtles-around-t+1 !=  turtles-around
        [ patch-update ] ; if there are different turtles around than the last time the patch was updated -> than it updates again
      ]
      set possible-destinations ( patch-set patch-here possible-destinations ) ; add the current patch to possible-destinations
      ask possible-destinations [set empty-patch TRUE] ; all possible-destinations set empty-patch to TRUE and only the selected destination
                                                       ; where the parent will move later will set empty-patch to false
      ; each patch part of possible-destinations has updated its utility values in its own list "list-empty-patch"
      let i [ group-parent ] of self
      ifelse ( i = 0 or i = 2 ) [ set i 0 ] [ set i 1 ] ; if the agent belongs to the green ethnicity -> make him green intolerant, else (if he belongs to the blue ethnicity) -> make him blue intolerant
      let list-utilities []
      let list-patch-id []
      ask possible-destinations
      [
        let t item i list-empty-patch ; each possi-desti takes the utility value in its list-empty-patch that corresponds to the group of the parent
        set list-utilities lput t list-utilities ; puts it in "list-utilities" (there is only one for each parent)
        let l patch-id
        set list-patch-id lput l list-patch-id ; and puts at the same time in "list-patch-id" its patch identity
                                               ; so that the two list are aligned
      ]
      let tot-uti sum list-utilities
      set list-utilities map [ j -> j / tot-uti ] list-utilities ; list-utilities contains the probabilities of moving to each possible destination according to equation 4 in paper, and sum of list-utilities = 1
      let selected-destination random-weighted list-patch-id list-utilities ;draws one value of the list with patch-id's with probabilities taken from the list-utilities
      move-to one-of patches with [ patch-id = selected-destination ] ; then move to the destination (remember that it can be the patch where the turtle was already because it had been added to the possible-destinations before)
      ask one-of patches with [ patch-id = selected-destination ] [ set empty-patch false ] ; ask the selected destination to set empty-patch to FALSE
    ]
  ]

end
;##############################################################################################################################################


;##############################################################################################################################################
to patch-update ; patch procedure: the empty patch is going to compute the list of satisfactions V it would provide to all four types of parents that could move there
                ; notice that it directly puts the numerator of equation 6 appendix A in paper i.e. exp(beta*V)

  set list-empty-patch []
  set turtles-around (turtles-on (patches in-radius radiusNeighborhood)) ; define the cells considered as being in the neighborhood
  ifelse count turtles-around > 0
  [
    let count-g1 count turtles-around with  [ identity = 45  ]
    let count-g2 count turtles-around with [ identity = 107 ]
    set x0-current x0-intolerant
    set m-current M-intolerant
    set list-empty-patch []
    let elem1 V count-g1 count-g2
    set elem1 exp (beta * elem1)
    set list-empty-patch lput elem1 list-empty-patch
    let elem2 V count-g2 count-g1
    set elem2 exp (beta * elem2)
    set list-empty-patch lput elem2 list-empty-patch
    set x0-current x0
    set m-current M
    let elem3 V count-g1 count-g2
    set elem3 exp (beta * elem3)
    set list-empty-patch lput elem3 list-empty-patch
    let elem4 V count-g2 count-g1
    set elem4 exp (beta * elem4)
    set list-empty-patch lput elem4 list-empty-patch
  ]
  [ set list-empty-patch [1 1 1 1] ]

end
;##############################################################################################################################################


;##############################################################################################################################################
to-report V [ similar-nearby other-nearby ] ; reports the ethnic satisfaction (V in paper) a patch or a school would provide to a parent of a given type
                                            ; see equation 2 in paper
  let total-nearby similar-nearby + other-nearby
  let xxx similar-nearby / total-nearby
  ifelse xxx <= x0-current
  [ report xxx / x0-current ]
  [ report m-current + ( ( (1 - xxx) * ( 1 - m-current ) ) /  ( 1 - x0-current ) ) ]
end
;##############################################################################################################################################


;##############################################################################################################################################
to-report random-weighted [ values weights ] ; takes two lists as input, one of school or patch-id and the second one, the associated probability of being selected
                                             ; then draws and reports one number in the first list, with the probability associated in the second list
  let selector ( random-float sum weights )
  let running-sum 0
  ( foreach values weights [ [ ?1 ?2 ] ->
    set running-sum ( running-sum + ?2 )
    if (running-sum > selector)
    [
      report ?1
    ]
  ] )
end
;##############################################################################################################################################


;##############################################################################################################################################
to update-globals ; computes the dissimilarity-indices by tolerance and ethnicity

  ;similarly to the setup procedure, need two embedded while loops to go over all squares of 25 patches with the same value of dissi-patch
  ; which corresponds to the S units in the paper
  let i 0
  let j 0
  let h max-pxcor
  set h abs h
  set h h + 1
  let b min-pycor
  set b abs b
  set b b + 1
  let d 0
  let t 0
  while [ j * 5 < b ]
  [
    while [ i * 5 < h ]
    [
      let neighborhood turtles-on patches with [ dissi-patch = j * 100 + i ]
      let #people-here count neighborhood
      let #col1-here count neighborhood with [ identity = 107 ]
      let #tol1-here count neighborhood with [ tolerance = true ]
      let #col2-here #people-here - #col1-here
      let #tol2-here #people-here - #tol1-here
      let #col1 count turtles with [identity = 107]
      let #tolerant count turtles with [tolerance = true]
      let dissi-col1 #col1-here / #col1
      let dissi-tol1 0
      if %-tolerant-agents != 0 [ set dissi-tol1 #tol1-here / #tolerant ]
      let dissi-col2 #col2-here / (#parents - #col1)
      let dissi-tol2 0
      if %-tolerant-agents != 0 [ set dissi-tol2 #tol2-here / (#parents - #tolerant) ]
      let index-of-dissimilarity abs (dissi-col1 - dissi-col2)
      let index-of-dissimilarity-tol 0
      ifelse %-tolerant-agents != 0 [ set index-of-dissimilarity-tol abs (dissi-tol1 - dissi-tol2) ] [set index-of-dissimilarity-tol 0 ]
      set i i + 1
      set d d + index-of-dissimilarity
      set t t + index-of-dissimilarity-tol
    ]
    set i 0
    set j j + 1
  ]
  set dissimilarity-index 0.5 * d
  set dissimilarity-index-tolerance 0.5 * t

end
;##############################################################################################################################################





;                                                                   ######
;                                                               ##############
;                                                          ########################
;                                                      ################################
;                                                  ########################################
;                                              ######### SCHOOL SEGREGATION MODEL ############
;                                                  ########################################
;                                                      ################################
;                                                          ########################
;                                                               ##############
;                                                                   ######





;##############################################################################################################################################
to setup2 ; setup the school segregation model over the map of the residential model -> create schools and assign parents to the closest school
  ;;  parlty copied from wilenski netlogo model in library http://ccl.northwestern.edu/netlogo/models/Voronoi
  ;; in this procedure every patch takes the color from the closest school

  ifelse no-double-click > 0  [show " Impossible, press the other setup button first "]
  [
    set no-double-click 1
    set available-colors shuffle filter [ ?1 -> (?1 mod 10 >= 3) and (?1 mod 10 <= 7) ]
    n-values 140 [ ?1 -> ?1 ]

    ask n-of number patches [ make-school ] ; the location of schools is set at random
    ask patches [ recolor ]; patches will take the color of the closest school
    set-default-shape links "line" ; for visualisation
    let n count turtles with [ parent? = true ]
    set max-number-kids n / number * limit-number-kids ; number= number of schools
    ; this sets the limit of links a school can have, and is a constant (cannot be change while the simulation is running)

    ask turtles with [ parent? = false ]
    [
      let residents-tempo turtles-on patches with [ pcolor = [color] of myself ]
      let parents turtles with [ parent? = true ]
      set residents parents with [ member? self residents-tempo ]
      ; uses the color of the patch to define residents : residents are parents in the voronoi diagram
      create-links-with residents
      ask turtles with [ parent? = true ] [ ask my-links [ set color [color] of myself ] ]
      ; create links between schools and parents
      school-update ; similar to patch update but for school: computes the satisfactions V that all types of parents would have if they would attend that school given the ethnic composition of the agents already attending the school
    ]

    ; empty-lists at the initialization
    set list-dissimilarity-index-tolerance-school []
    set list-dissimilarity-index-school []

    update-globals2

    ;to facilitate visualization
    ask patches [ set pcolor white ]
    ask turtles with [parent? = true] [ set size 0.1 ]
    set #parents count links

    reset-ticks
  ]
end
;##############################################################################################################################################


;##############################################################################################################################################
to go2
 school-choice
  if update-globals-during-run = true
  [ ; to lighten the computational burden, not compulsory to compute the gloabls at every iteration
    if ticks mod update-globals-every = 0
    [ update-globals2 ]
  ]
  tick
end
;##############################################################################################################################################


;##############################################################################################################################################
to school-choice ; selected parents take a school decision : either stay where they are already or choose a new school

  ask  n-of number-agents-selected turtles with [ parent? = true ]
  [; selects at random x parents at every iteration that will take a school decision (either choose a new school or remain at the one they are attending already).
    let previous-school [ who ] of link-neighbors ; previous-school is not an agentset
    set previous-school item 0 previous-school

    ask turtles with [ parent? = false ]
    [ ;schools update the ratios of schools that need to be updated
      let residents-t+1 link-neighbors
      if  residents-t+1 !=  residents
        [ school-update ]
    ] ; if there are different parents connected than the last time the school was updated -> than it updates again

    let i [ group-parent ] of self
    let list-utilities-school []
    let list-patch-id-school []

    ask turtles with [ parent? = false ]
    [ ; ask schools
      let k count my-links
      if ( k < max-number-kids ) or ( who = previous-school )
      [
       let t item i list-school ; each school extract from list-school the utility that interests the agent (myself)
       let r distance myself
       let normalized-distance ( max-distance - r ) / max-distance
       let total-uti pref t normalized-distance ; calculate the value of U equation 1 in paper based on V, D and alpha
       let expo-transfo exp ( beta * total-uti ) ; contrarily to the patch-update procedure the list-school only contain the V satisfaction and not exp(beta*V)
       set list-utilities-school lput expo-transfo list-utilities-school
       let l [ who ] of self
       set list-patch-id-school lput l list-patch-id-school
      ]
    ] ; and puts at the same time in "list-patch-id-school" its who so that the two list are aligned

    let tot-uti sum list-utilities-school
    set list-utilities-school map [ j -> j / tot-uti ] list-utilities-school ; transform into probabilities with sum of list = 1
    let selected-school random-weighted list-patch-id-school list-utilities-school
    if selected-school != previous-school
    [
      ask my-links
      [ die ]
      create-link-with one-of turtles with [ who = selected-school ]
      [ set color [color] of myself ]
    ]
  ]
end
;##############################################################################################################################################


;##############################################################################################################################################
to school-update ; everytime a school is called, it updates its list of satisfaction (V in the paper)

  set list-school []
  set residents link-neighbors ; residents (i.e. students) is computed again every time the school updates and then kept in memory
  ifelse count residents > 0
  [ ; if the school is not empty (i.e. has students)
    let count-g1 count residents with  [ identity = 45 ] ; count parents belonging to G1 in the school
    let count-g2 count residents with [ identity = 107 ] ; count parents belonging to G2 in the school
    ;first compute the satisfiactions V for intolerant parents of both ethnic groups
    set x0-current x0-intolerant
    set m-current M-intolerant
    set list-school []
    let elem1 V count-g1 count-g2
    set list-school lput elem1 list-school
    let elem2 V count-g2 count-g1
    set list-school lput elem2 list-school
    ;second compute the satisfiactions V for tolerant parents of both ethnic groups
    set x0-current x0
    set m-current M
    let elem3 V count-g1 count-g2
    set list-school lput elem3 list-school
    let elem4 V count-g2 count-g1
    set list-school lput elem4 list-school
  ]
  [ ; if there are no students in the school -> set all utilities equal to 1 (this avoids division by 0 errors).
    set list-school [1 1 1 1]
  ]

end
;##############################################################################################################################################


;##############################################################################################################################################
to update-globals2 ; update the average satisfication V in the population of 1/parents 2/intolerant parents 3/ tolerant parents
                   ; and the dissimilarity indices by ethnicity and tolerance

  ask turtles with [parent? = true]
  ; get the satisfaction-of-school (i.e. satisfaction V in the paper (utility without taking into account distance)) of the school
  [
    let i [group-parent] of self
    set i i
    let t 0
    ask link-neighbors [set t item i list-school]
    set satisfaction-of-school t
  ]

  ; compute the average satisfication V in the population of parents
  let ut sum [satisfaction-of-school] of turtles with [parent? = true]
  set school-utility ut / #parents
  ; compute the average satisfication V in the population of tolerant parents
  let utT sum [satisfaction-of-school] of turtles with [parent? = true and tolerance = true ]
  set school-utilityT utT / #parentsT
  ; compute the average satisfication V in the population of intolerant parents
  let utINT sum [satisfaction-of-school] of turtles with [parent? = true and tolerance = false ]
  set school-utilityINT utINT / #parentsINT

  ask turtles with [parent? = false]
  [ ; each school computes its part of the dissimilarity index by ethnicity and by tolerance (equation 5 in paper)
    ; -> absolute value (e1s/E1 - e2s/E2)
    let #people-here count residents
    let #col1-here count residents with [ identity = 107 ]
    let #tol1-here count residents with [ tolerance = true ]
    let #col2-here #people-here - #col1-here
    let #tol2-here #people-here - #tol1-here
    let #col1 count turtles with [parent? = true and identity = 107]
    let #tolerant count turtles with [parent? = true and tolerance = true]
    let dissi-col1 #col1-here / (#col1)
    let dissi-tol1 0
    if %-tolerant-agents != 0 [ set dissi-tol1 #tol1-here / #tolerant]
    let dissi-col2 #col2-here / ( #parents - #col1 )
    let dissi-tol2 0
    if %-tolerant-agents != 0 [ set dissi-tol2 #tol2-here / (#parents - #tolerant) ]
    set index-of-dissimilarityS abs (dissi-col1 - dissi-col2)
    set index-of-dissimilarity-tolS abs (dissi-tol1 - dissi-tol2)
  ]

  ; then the dissimilarity indices by tolerance and ethnicity equal the sum of absolute value (e1s/E1 - e2s/E2) of alls schools * 0.5 (see equation 5 paper)
  let d sum [ index-of-dissimilarityS ]  of turtles with [parent? = false]
  let t sum [ index-of-dissimilarity-tolS ] of turtles with [parent? = false]
  set dissimilarity-index-school 0.5 * d
  set dissimilarity-index-tolerance-school 0.5 * t

  set list-dissimilarity-index-tolerance-school lput dissimilarity-index-tolerance-school list-dissimilarity-index-tolerance-school
  set list-dissimilarity-index-school lput dissimilarity-index-school list-dissimilarity-index-school

end
;##############################################################################################################################################


;##############################################################################################################################################
to make-school
  ; patch procedure: create a new school (turtle)
  sprout 1
  [
    set size 1.5
    set shape "circle 2"
    set color first available-colors ; if  "number" (-> number of schools) is superior to # elements in list available-colors -> bug
    set available-colors butfirst available-colors
    set parent? false
  ]
end
;##############################################################################################################################################


;##############################################################################################################################################
to recolor
  let schools turtles with [parent? = false]
  set pcolor [color] of min-one-of schools [distance myself]
end
;##############################################################################################################################################


;##############################################################################################################################################
to-report pref [ ethnic-u norma-dist ] ; corresponds to the utility U (equation 1 in paper)
  report ( ethnic-u ^ alpha ) * ( norma-dist ^ ( 1 - alpha ) )
end
;##############################################################################################################################################


;##############################################################################################################################################
to goBis ; command to run behavior space experiment with number-ticks-FM corresponding to the number of iterations we let the residential model run
         ; and number-ticks-SC corresponding to the number of iterations we let the school choice model tun
    while [ ticks < number-ticks-FM ] [ go ]
  update-globals
    setup2
    while [ ticks < number-ticks-SC ] [ go2 ]
  update-globals2
    stop

  end
;##############################################################################################################################################
@#$#@#$#@
GRAPHICS-WINDOW
278
10
716
449
-1
-1
5.38
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
79
-79
0
1
1
1
ticks
30.0

BUTTON
733
73
794
106
setup
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
865
73
920
106
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
798
73
862
106
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
0

SLIDER
12
36
267
69
%-empty-patches
%-empty-patches
0
1
0.1
0.01
1
NIL
HORIZONTAL

MONITOR
858
17
924
62
# agents
count turtles
1
1
11

SLIDER
11
70
267
103
%-group2
%-group2
0.1
1
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
12
346
221
379
x0
x0
0
1
0.99
0.01
1
NIL
HORIZONTAL

SLIDER
12
380
221
413
M
M
0
1
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
12
170
215
203
beta
beta
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
12
203
214
236
number-of-destinations
number-of-destinations
1
50
8.0
1
1
NIL
HORIZONTAL

SLIDER
11
104
266
137
%-tolerant-agents
%-tolerant-agents
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
12
443
217
476
x0-intolerant
x0-intolerant
0
1
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
12
477
217
510
M-intolerant
M-intolerant
0
1
1.0
0.01
1
NIL
HORIZONTAL

TEXTBOX
15
312
165
340
Utility function parameters of tolerant agents:
11
0.0
1

TEXTBOX
13
413
163
441
Utility function parameters of intolerant agents:
11
0.0
1

TEXTBOX
13
141
163
169
Parameters for the overall population:
11
0.0
1

TEXTBOX
15
10
165
28
Demographical parameters:
11
0.0
1

SLIDER
734
111
935
144
radiusNeighborhood
radiusNeighborhood
1
20
6.0
1
1
NIL
HORIZONTAL

BUTTON
740
237
810
270
NIL
setup2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
737
335
965
368
number
number
2
40
30.0
1
1
NIL
HORIZONTAL

BUTTON
880
237
966
270
NIL
go2
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
736
278
964
311
alpha
alpha
0
1
1.0
0.01
1
NIL
HORIZONTAL

BUTTON
813
237
876
270
NIL
go2
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
983
354
1268
546
utility-school-global
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"all" 1.0 0 -16777216 true "" "plot school-utility"
"tolerant" 1.0 0 -7500403 true "" "plot school-utilityT"
"intolerant" 1.0 0 -2674135 true "" "plot school-utilityINT"

PLOT
981
22
1268
172
dissimilarity-index
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot dissimilarity-index"

PLOT
982
174
1268
354
dissimilarity-index-school
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Ethnic" 1.0 0 -2674135 true "" "plot dissimilarity-index-school"
"Tolerance" 1.0 0 -13345367 true "" "plot dissimilarity-index-tolerance-school"

SLIDER
12
237
213
270
update-globals-every
update-globals-every
0
100
10.0
1
1
NIL
HORIZONTAL

TEXTBOX
738
10
853
67
RESIDENTIAL MODEL'S PARAMETERS
15
0.0
0

TEXTBOX
735
192
885
230
SCHOOL MODEL'S PARAMETERS
15
0.0
0

SLIDER
734
144
935
177
number-agents-selected
number-agents-selected
1
250
250.0
1
1
NIL
HORIZONTAL

SLIDER
737
446
965
479
limit-number-kids
limit-number-kids
1
12
2.1
0.05
1
NIL
HORIZONTAL

INPUTBOX
1263
912
1824
972
export-directory
/Users/philippesage/Documents/Lucas/results experiment
1
0
String

SLIDER
14
618
186
651
number-ticks-SC
number-ticks-SC
0
250
1400.0
10
1
NIL
HORIZONTAL

SLIDER
14
583
186
616
number-ticks-FM
number-ticks-FM
0
250
34.0
2
1
NIL
HORIZONTAL

SWITCH
737
538
947
571
no-tolerant-residentialM
no-tolerant-residentialM
0
1
-1000

SWITCH
12
272
213
305
update-globals-during-run
update-globals-during-run
0
1
-1000

TEXTBOX
738
318
888
336
number of schools:
11
0.0
1

TEXTBOX
740
490
890
532
Decide whether the tolerant agents are tolerant in the residential model: 
11
0.0
1

TEXTBOX
736
375
886
445
maximum capacity of schools (to replicate main results of the paper set it to 2.1, correspond to 403 students)\n
11
0.0
1

TEXTBOX
15
515
268
585
When using the goBis procedure to run behavior space experiment only: decide how many iterations one wants to run the residential (FM) and school choice (SC) models:
11
0.0
1

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

face-happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face-sad
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

person2
false
0
Circle -7500403 true true 105 0 90
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 285 180 255 210 165 105
Polygon -7500403 true true 105 90 15 180 60 195 135 105

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

square - happy
false
0
Rectangle -7500403 true true 30 30 270 270
Polygon -16777216 false false 75 195 105 240 180 240 210 195 75 195

square - unhappy
false
0
Rectangle -7500403 true true 30 30 270 270
Polygon -16777216 false false 60 225 105 180 195 180 240 225 75 225

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

square-small
false
0
Rectangle -7500403 true true 45 45 255 255

square-x
false
0
Rectangle -7500403 true true 30 30 270 270
Line -16777216 false 75 90 210 210
Line -16777216 false 210 90 75 210

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

triangle2
false
0
Polygon -7500403 true true 150 0 0 300 300 300

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
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="first_test_simulations" repetitions="4" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>goBis</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="update-globals-every">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;C:/Users/Philippe/Documents/Lucas/School Segregation Model/Results&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="update-globals-every">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/lsage/Documents/Sociologie/Recherche/Groningen/SchoolM/Simulations&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Results 2" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>goBis</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="update-globals-every">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="0"/>
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.2"/>
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.2"/>
      <value value="0.25"/>
      <value value="0.3"/>
      <value value="0.35"/>
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;C:/Users/Philippe/Documents/Lucas/School Segregation Model/Results 2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.4"/>
      <value value="0.45"/>
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Results not used" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>goBis</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="update-globals-every">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="37"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="0"/>
      <value value="2"/>
      <value value="4"/>
      <value value="6"/>
      <value value="8"/>
      <value value="10"/>
      <value value="12"/>
      <value value="14"/>
      <value value="16"/>
      <value value="18"/>
      <value value="20"/>
      <value value="22"/>
      <value value="24"/>
      <value value="26"/>
      <value value="28"/>
      <value value="30"/>
      <value value="32"/>
      <value value="34"/>
      <value value="36"/>
      <value value="38"/>
      <value value="40"/>
      <value value="42"/>
      <value value="44"/>
      <value value="46"/>
      <value value="48"/>
      <value value="50"/>
      <value value="52"/>
      <value value="54"/>
      <value value="56"/>
      <value value="58"/>
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.6"/>
      <value value="0.8"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="170"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;C:/Users/Philippe/Documents/Lucas/School Segregation Model/Results 1&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.55"/>
      <value value="36"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Results 1" repetitions="6" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>goBis</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="update-globals-every">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="0"/>
      <value value="3"/>
      <value value="6"/>
      <value value="9"/>
      <value value="12"/>
      <value value="15"/>
      <value value="18"/>
      <value value="21"/>
      <value value="24"/>
      <value value="27"/>
      <value value="30"/>
      <value value="33"/>
      <value value="36"/>
      <value value="39"/>
      <value value="42"/>
      <value value="45"/>
      <value value="48"/>
      <value value="51"/>
      <value value="54"/>
      <value value="57"/>
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.6"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;C:/Users/Philippe/Documents/Lucas/School Segregation Model/Results 1&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Results 3" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="0"/>
      <value value="2"/>
      <value value="4"/>
      <value value="6"/>
      <value value="8"/>
      <value value="10"/>
      <value value="12"/>
      <value value="14"/>
      <value value="16"/>
      <value value="18"/>
      <value value="20"/>
      <value value="22"/>
      <value value="24"/>
      <value value="26"/>
      <value value="28"/>
      <value value="30"/>
      <value value="32"/>
      <value value="34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.6"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;C:/Users/Philippe/Documents/Lucas/School Segregation Model/Results 3&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;C:/Users/Philippe/Documents/Lucas/School Segregation Model/Results 3&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Results 4" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>goBis</go>
    <metric>ID</metric>
    <enumeratedValueSet variable="update-globals-every">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="0"/>
      <value value="2"/>
      <value value="4"/>
      <value value="6"/>
      <value value="8"/>
      <value value="10"/>
      <value value="12"/>
      <value value="14"/>
      <value value="16"/>
      <value value="18"/>
      <value value="20"/>
      <value value="22"/>
      <value value="24"/>
      <value value="26"/>
      <value value="28"/>
      <value value="30"/>
      <value value="32"/>
      <value value="34"/>
      <value value="36"/>
      <value value="38"/>
      <value value="40"/>
      <value value="42"/>
      <value value="44"/>
      <value value="46"/>
      <value value="48"/>
      <value value="50"/>
      <value value="52"/>
      <value value="54"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="1400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>goBis</go>
    <metric>ID</metric>
    <metric>dissimilarity-index</metric>
    <metric>dissimilarity-index-tolerance</metric>
    <metric>dissimilarity-index-school</metric>
    <metric>dissimilarity-index-tolerance-school</metric>
    <metric>school-utility</metric>
    <metric>school-utilityT</metric>
    <metric>school-utilityINT</metric>
    <enumeratedValueSet variable="update-globals-every">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="0"/>
      <value value="2"/>
      <value value="4"/>
      <value value="6"/>
      <value value="8"/>
      <value value="10"/>
      <value value="12"/>
      <value value="14"/>
      <value value="16"/>
      <value value="18"/>
      <value value="20"/>
      <value value="22"/>
      <value value="24"/>
      <value value="26"/>
      <value value="28"/>
      <value value="30"/>
      <value value="32"/>
      <value value="34"/>
      <value value="36"/>
      <value value="38"/>
      <value value="40"/>
      <value value="42"/>
      <value value="44"/>
      <value value="46"/>
      <value value="48"/>
      <value value="50"/>
      <value value="52"/>
      <value value="54"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="1400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="01-07-2019 only 50 and 0 segregated continuum" repetitions="3" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
      <value value="6"/>
      <value value="7"/>
      <value value="8"/>
      <value value="9"/>
      <value value="10"/>
      <value value="11"/>
      <value value="12"/>
      <value value="13"/>
      <value value="14"/>
      <value value="15"/>
      <value value="16"/>
      <value value="17"/>
      <value value="18"/>
      <value value="19"/>
      <value value="20"/>
      <value value="21"/>
      <value value="22"/>
      <value value="23"/>
      <value value="24"/>
      <value value="25"/>
      <value value="26"/>
      <value value="27"/>
      <value value="28"/>
      <value value="29"/>
      <value value="30"/>
      <value value="31"/>
      <value value="32"/>
      <value value="33"/>
      <value value="34"/>
      <value value="35"/>
      <value value="36"/>
      <value value="37"/>
      <value value="38"/>
      <value value="39"/>
      <value value="40"/>
      <value value="41"/>
      <value value="42"/>
      <value value="43"/>
      <value value="45"/>
      <value value="46"/>
      <value value="47"/>
      <value value="48"/>
      <value value="49"/>
      <value value="50"/>
      <value value="51"/>
      <value value="52"/>
      <value value="53"/>
      <value value="54"/>
      <value value="55"/>
      <value value="56"/>
      <value value="57"/>
      <value value="58"/>
      <value value="59"/>
      <value value="60"/>
      <value value="61"/>
      <value value="62"/>
      <value value="63"/>
      <value value="64"/>
      <value value="65"/>
      <value value="66"/>
      <value value="67"/>
      <value value="68"/>
      <value value="69"/>
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="0"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="02-07-2019 only 50 and 0 mixed continuum" repetitions="3" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
      <value value="6"/>
      <value value="7"/>
      <value value="8"/>
      <value value="9"/>
      <value value="10"/>
      <value value="11"/>
      <value value="12"/>
      <value value="13"/>
      <value value="14"/>
      <value value="15"/>
      <value value="16"/>
      <value value="17"/>
      <value value="18"/>
      <value value="19"/>
      <value value="20"/>
      <value value="21"/>
      <value value="22"/>
      <value value="23"/>
      <value value="24"/>
      <value value="25"/>
      <value value="26"/>
      <value value="27"/>
      <value value="28"/>
      <value value="29"/>
      <value value="30"/>
      <value value="31"/>
      <value value="32"/>
      <value value="33"/>
      <value value="34"/>
      <value value="35"/>
      <value value="36"/>
      <value value="37"/>
      <value value="38"/>
      <value value="39"/>
      <value value="40"/>
      <value value="41"/>
      <value value="42"/>
      <value value="43"/>
      <value value="45"/>
      <value value="46"/>
      <value value="47"/>
      <value value="48"/>
      <value value="49"/>
      <value value="50"/>
      <value value="51"/>
      <value value="52"/>
      <value value="53"/>
      <value value="54"/>
      <value value="55"/>
      <value value="56"/>
      <value value="57"/>
      <value value="58"/>
      <value value="59"/>
      <value value="60"/>
      <value value="63"/>
      <value value="66"/>
      <value value="69"/>
      <value value="72"/>
      <value value="75"/>
      <value value="78"/>
      <value value="81"/>
      <value value="84"/>
      <value value="87"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="0"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="03-07-2019 only 50 and 0 mixed continuum" repetitions="3" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
      <value value="6"/>
      <value value="7"/>
      <value value="8"/>
      <value value="9"/>
      <value value="10"/>
      <value value="11"/>
      <value value="12"/>
      <value value="13"/>
      <value value="14"/>
      <value value="15"/>
      <value value="16"/>
      <value value="17"/>
      <value value="18"/>
      <value value="19"/>
      <value value="20"/>
      <value value="21"/>
      <value value="22"/>
      <value value="23"/>
      <value value="24"/>
      <value value="25"/>
      <value value="26"/>
      <value value="27"/>
      <value value="28"/>
      <value value="29"/>
      <value value="30"/>
      <value value="31"/>
      <value value="32"/>
      <value value="33"/>
      <value value="34"/>
      <value value="35"/>
      <value value="36"/>
      <value value="37"/>
      <value value="38"/>
      <value value="39"/>
      <value value="40"/>
      <value value="41"/>
      <value value="42"/>
      <value value="43"/>
      <value value="45"/>
      <value value="46"/>
      <value value="47"/>
      <value value="48"/>
      <value value="49"/>
      <value value="50"/>
      <value value="51"/>
      <value value="52"/>
      <value value="53"/>
      <value value="54"/>
      <value value="55"/>
      <value value="56"/>
      <value value="57"/>
      <value value="58"/>
      <value value="59"/>
      <value value="60"/>
      <value value="63"/>
      <value value="66"/>
      <value value="69"/>
      <value value="72"/>
      <value value="75"/>
      <value value="78"/>
      <value value="81"/>
      <value value="84"/>
      <value value="87"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="04-07-2019 only 50 and 0 mixed continuum" repetitions="3" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
      <value value="6"/>
      <value value="7"/>
      <value value="8"/>
      <value value="9"/>
      <value value="10"/>
      <value value="11"/>
      <value value="12"/>
      <value value="13"/>
      <value value="14"/>
      <value value="15"/>
      <value value="16"/>
      <value value="17"/>
      <value value="18"/>
      <value value="19"/>
      <value value="20"/>
      <value value="21"/>
      <value value="22"/>
      <value value="23"/>
      <value value="24"/>
      <value value="25"/>
      <value value="26"/>
      <value value="27"/>
      <value value="28"/>
      <value value="29"/>
      <value value="30"/>
      <value value="31"/>
      <value value="32"/>
      <value value="33"/>
      <value value="34"/>
      <value value="35"/>
      <value value="36"/>
      <value value="37"/>
      <value value="38"/>
      <value value="39"/>
      <value value="40"/>
      <value value="41"/>
      <value value="42"/>
      <value value="43"/>
      <value value="45"/>
      <value value="46"/>
      <value value="47"/>
      <value value="48"/>
      <value value="49"/>
      <value value="50"/>
      <value value="51"/>
      <value value="52"/>
      <value value="53"/>
      <value value="54"/>
      <value value="55"/>
      <value value="56"/>
      <value value="57"/>
      <value value="58"/>
      <value value="59"/>
      <value value="60"/>
      <value value="63"/>
      <value value="66"/>
      <value value="69"/>
      <value value="72"/>
      <value value="75"/>
      <value value="78"/>
      <value value="81"/>
      <value value="84"/>
      <value value="87"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="29-08-2019 missing runs for 44 segregated continuum" repetitions="3" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="0"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="29-08-2019 missing 44 runs mixed continuum" repetitions="3" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="0"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="29-08-2019 long run - replication" repetitions="50" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="0"/>
      <value value="16"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.3"/>
      <value value="0.6"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="1400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="29-08-2019 long run missing alpha 0" repetitions="26" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="1400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="29-08-2019 long run missing alpha 0 rdi high" repetitions="50" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="1400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="29-08-2019 long run complex segre" repetitions="50" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.3"/>
      <value value="0.6"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="1400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="29-08-2019 long run missing alpha 0,3" repetitions="26" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="1400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="29-08-2019 long run rdi high simple segre" repetitions="50" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.3"/>
      <value value="0.6"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="1400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="03-02-2019 long run" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.3"/>
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="1400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="01-09-2019 long run - simple - high RDI" repetitions="50" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>goBis</go>
    <enumeratedValueSet variable="update-globals-every">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp_untolerant">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-FM">
      <value value="34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.3"/>
      <value value="0.6"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-ticks-SC">
      <value value="1400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no-tolerant-residentialM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-tolerant-agents">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M_untolerant">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="M">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiusNeighborhood">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-directory">
      <value value="&quot;/Users/philippesage/Documents/Lucas/results experiment&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_empty_patches">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-agents-selected">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-destinations">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-number-kids">
      <value value="2.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fp">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_pop_2">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="update-globals-during-run">
      <value value="false"/>
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

line
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
14
@#$#@#$#@
0
@#$#@#$#@
