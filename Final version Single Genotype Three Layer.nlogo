;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                        ;;;
;;;  Copyright 2017 Jeffrey Pfaffmann and Elaine Reynolds                  ;;;
;;;                                                                        ;;;
;;;  This program is free software: you can redistribute it and/or modify  ;;;
;;;  it under the terms of the GNU General Public License as published by  ;;;
;;;  the Free Software Foundation, either version 3 of the License, or     ;;;
;;;  (at your option) any later version.                                   ;;;
;;;                                                                        ;;;
;;;  This program is distributed in the hope that it will be useful,       ;;;
;;;  but WITHOUT ANY WARRANTY; without even the implied warranty of        ;;;
;;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         ;;;
;;;  GNU General Public License for more details.                          ;;;
;;;                                                                        ;;;
;;;  You should have received a copy of the GNU General Public License     ;;;
;;;  along with this program.  If not, see http://www.gnu.org/licenses/    ;;;
;;;                                                                        ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

globals [

  ;;;; Used to determine the border around the cell sheet.
  ;;;; Thus these are cosmetic and to not contribute to simulation.

  diameter                 ;;;; diameter of the cell
  lipid-distance           ;;;; distance between lipids on the membrane

  delta-transcription-rate ;;;;; computed rate modulated by cleaved notch
  delta2-transcription-rate ; added for second pathway
  notch-transcription-rate ;;;;; computed rate modulated by cleaved notch
  notch2-transcription-rate ; added for second pathway

  unitMove                 ;;;;; computed move on radius

  radius
  radiusFraction
  lipid-density
  notch-cleaved-diffusion-time-signal
  notch2-cleaved-diffusion-time-signal
  cell-row-cnt
  cell-col-cnt
  centersomeSize
  deltaAge
  notchAge

]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; create breeds ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;=====================================================================
;; the central nucleus

breed [nucleus-breed    nucleus]

nucleus-breed-own [

  lipid-set    ;-- set of lipids owned by nucleus
  lipid-start  ;-- first id in range of lipid names
  lipid-end    ;-- last id in range of lipid names

  cleaved-nuc-notch-count-value
  cleaved2-nuc-notch-count-value

  roset-neighbors
  currentNuclearNotchCnt
  currentNuclearNotch2Cnt
  placed
]
;;=====================================================================


;;=====================================================================
;; the proteins that compose the membrane

breed [lipid-breed lipid]

lipid-breed-own [

  parent     ;-- owning nucleus
  parent-who ;-- owning nucleus id

  left-mem  ;-- lipid to left
  right-mem ;-- lipid to right

  curr-proteins ;-- membrane proteins currently stored at that region
  border-region ;-- the lipids in the neighboring cell region
]
;;=====================================================================


;;=====================================================================
;; recently transcribed delta transporting to membrane

breed [delta-breed       delta]

delta-breed-own [
  birth      ;-- the tick that the delta was created
  parent     ;-- owning nucleus
  parent-who ;-- owning nucleus id
  mem-time   ;-- the time delta became a membrane.
]
;;=====================================================================
;second synotch path to generate a third cell line, replication of the code with 2 after names, additional conditions for its activation will occur later.

breed [delta2-breed       delta2]

delta2-breed-own [
  birth      ;-- the tick that the delta was created
  parent     ;-- owning nucleus
  parent-who ;-- owning nucleus id
  mem-time   ;-- the time delta became a membrane.
]
;;=====================================================================


;;=====================================================================
;; the delta diffusing on the membrane

breed [delta-mem-breed   delta-mem]

delta-mem-breed-own [
  birth       ;-- the tick that the original delta was created
  local-lipid ;-- the lipid that the membrane delta is associated with
  parent      ;-- owning nucleus
  parent-who  ;-- owning nucleus id
  mem-time    ;-- the time delta became a membrane.
]
;;=====================================================================
breed [delta2-mem-breed   delta2-mem]

delta2-mem-breed-own [
  birth       ;-- the tick that the original delta was created
  local-lipid ;-- the lipid that the membrane delta is associated with
  parent      ;-- owning nucleus
  parent-who  ;-- owning nucleus id
  mem-time    ;-- the time delta became a membrane.
]
;;=====================================================================



;;=====================================================================
;; the delta diffusing on the membrane in active form

breed [delta-mem-prime-breed   delta-mem-prime]

delta-mem-prime-breed-own [
  birth       ;-- the tick that the original delta was created
  local-lipid ;-- the lipid that the membrane delta prime is associated with
  parent      ;-- owning nucleus
  parent-who  ;-- owning nucleus id
  mem-time    ;-- the time delta became a membrane.
]
;;=====================================================================
breed [delta2-mem-prime-breed   delta2-mem-prime]

delta2-mem-prime-breed-own [
  birth       ;-- the tick that the original delta was created
  local-lipid ;-- the lipid that the membrane delta prime is associated with
  parent      ;-- owning nucleus
  parent-who  ;-- owning nucleus id
  mem-time    ;-- the time delta became a membrane.
]
;;=====================================================================


;;=====================================================================
;; recently transcribed notch transporting to membrane

breed [notch-breed      notch]

notch-breed-own [
  birth      ;-- the tick that the notch was created
  parent     ;-- owning nucleus
  parent-who ;-- owning nucleus id
]
;;=====================================================================
breed [notch2-breed      notch2]

notch2-breed-own [
  birth      ;-- the tick that the notch was created
  parent     ;-- owning nucleus
  parent-who ;-- owning nucleus id
]
;;=====================================================================


;;=====================================================================
;; notch that is diffusing on membrane

breed [notch-mem-breed  notch-mem]

notch-mem-breed-own [
  birth       ;-- the tick that the original notch was created
  parent      ;-- owning nucleus
  parent-who  ;-- owning nucleus id
  local-lipid ;-- the lipid that the membrane notch is associated with
  protected
]
;;=====================================================================

breed [notch2-mem-breed  notch2-mem]

notch2-mem-breed-own [
  birth       ;-- the tick that the original notch was created
  parent      ;-- owning nucleus
  parent-who  ;-- owning nucleus id
  local-lipid ;-- the lipid that the membrane notch is associated with
  protected
]
;;=====================================================================


;;=====================================================================
;; diffusing notch

breed [cleaved-notch-breed  cleaved-notch]

cleaved-notch-breed-own [
  birth       ;-- the tick that the original notch was created
  parent      ;-- owning nucleus
  parent-who  ;-- owning nucleus id
  time-cleaved;-- time the protein was cleaved and sent to nucleus
  indCleavedDiffTime
]
;;=====================================================================
breed [cleaved2-notch-breed  cleaved2-notch]

cleaved2-notch-breed-own [
  birth       ;-- the tick that the original notch was created
  parent      ;-- owning nucleus
  parent-who  ;-- owning nucleus id
  time-cleaved;-- time the protein was cleaved and sent to nucleus
  indCleavedDiffTime
]
;;=====================================================================


;;=====================================================================
;; cleaved notch that has reached nucleus and modulating transcription

breed [notch-nuc-breed  nucleus-notch]

notch-nuc-breed-own [
  birth       ;-- the tick that the original notch was created
  parent      ;-- owning nucleus
  parent-who  ;-- owning nucleus id
  time-cleaved;-- time the protein was cleaved and sent to nucleus
  indCleavedDiffTime
  time-nuc    ;-- time the protein was cleaved and sent to nucleus
]
;;=====================================================================
breed [notch2-nuc-breed  nucleus2-notch]

notch2-nuc-breed-own [
  birth       ;-- the tick that the original notch was created
  parent      ;-- owning nucleus
  parent-who  ;-- owning nucleus id
  time-cleaved;-- time the protein was cleaved and sent to nucleus
  indCleavedDiffTime
  time-nuc    ;-- time the protein was cleaved and sent to nucleus
]
;;=====================================================================


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; setup proceedure   ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; executed initially ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to setup

  ;;--------------------------------------------------
  ;; initialize the space as empty
  clear-all
  ;;--------------------------------------------------

  ;;--------------------------------------------------
  ;; establish the random seed
  set current-seed new-seed
  random-seed current-seed
  ;;--------------------------------------------------

  ;;--------------------------------------------------
  ;; initialize all globals
  set radius          10
  set radiusFraction  0.0550
  set diameter        (radius * 2)
  set lipid-density    12

  set cell-row-cnt      rows-of-cells
  set cell-col-cnt      columns-of-cells
  set centersomeSize   10
  set deltaAge        400
  set notchAge        400


  set notch-cleaved-diffusion-time-signal (notch-cleaved-diffusion-time / 4.0)
  ;duplicate parameters for the second notch signaling
  set notch2-cleaved-diffusion-time-signal (notch2-cleaved-diffusion-time / 4.0)

  set lipid-distance     (radius / lipid-density)

  ;; specifies the granularity of the physical space and influences
  ;; distance components move.
  set unitMove (radius * radiusFraction)

  ;;--------------------------------------------------
  ;; initialize transcription to base rate
  set delta-transcription-rate delta-transcription-initial-rate
  set delta2-transcription-rate delta2-transcription-initial-rate
  set notch-transcription-rate notch-transcription-initial-rate
  set notch2-transcription-rate notch2-transcription-initial-rate

  ;;--------------------------------------------------

  ;;--------------------------------------------------
  ;; create the nucleus-breed
  layout-nucleus-breed-sheet
  ;;--------------------------------------------------

  ;;--------------------------------------------------
  ;; ask all nucleus to create a roset neighbor list
  ask nucleus-breed [
    set roset-neighbors (turtle-set nucleus-breed with [(self != myself) and (distance myself) < (diameter + 1)])
  ]
  ;;--------------------------------------------------

  ;;--------------------------------------------------
  ;; create the cell lipids
  layout-lipids
  ;;--------------------------------------------------



  reset-ticks
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;; go proceedure      ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;; run with each tick ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go-1

  go-x 1

end

to go-1000

  go-x 1000

end

to go-10000
  go-x 10000
end

to go-5000
  go-x 5000
end

to go-x [interations]

  print (word " ticks " ticks "   :  " date-and-time )

  repeat interations [go]

end


to go

  age-out-proteins    ;; remove proteins that have hit the maximum age

  plot-current-data

  transcribe-proteins ;; transcribe any new proteins
                       ; if the cell is not a 'neuron' it will begin activating the second notch signaling to turn neurons into a third line if the nuclear notch passes a threshold value

  diffuse-proteins    ;; diffuse all diffusable components
                       ; second notch signal will diffuse inside this block

  transform-proteins  ;; perform all interprotein manipulations
  transform-proteins2 ; second notch signal transformation

  tick                ;; clock tick
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; eliminate old proteins ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ageout mechanism for the model
to age-out-proteins

  ask delta-breed            with [ticks > ( birth + deltaAge )] [ die ]
  ask delta-mem-breed        with [ticks > ( birth + deltaAge )] [ die ]
  ask delta-mem-prime-breed  with [ticks > ( birth + deltaAge )] [ die ]

  ask notch-breed            with [ticks > ( birth + notchAge )] [ die ]
  ask notch-mem-breed        with [ticks > ( birth + notchAge )] [ die ]

  ; cleaved notch also provides protein tracking information
  ask cleaved-notch-breed    with [ticks > ( birth + notchAge )] [ die ]

  ; protein production signal value is reduced as nuclear notch is
  ; removed
  ask notch-nuc-breed        with [ticks > ( birth + notchAge )] [

    ask parent [
      set cleaved-nuc-notch-count-value ( cleaved-nuc-notch-count-value - 1 )
    ]

    die
  ]

  ; kill of any of the second notch pathway also
  ask delta2-breed            with [ticks > ( birth + deltaAge )] [ die ]
  ask delta2-mem-breed        with [ticks > ( birth + deltaAge )] [ die ]
  ask delta2-mem-prime-breed  with [ticks > ( birth + deltaAge )] [ die ]

  ask notch2-breed            with [ticks > ( birth + notchAge )] [ die ]
  ask notch2-mem-breed        with [ticks > ( birth + notchAge )] [ die ]

  ; cleaved notch also provides protein tracking information
  ask cleaved2-notch-breed    with [ticks > ( birth + notchAge )] [ die ]

  ; protein production signal value is reduced as nuclear notch is
  ; removed
  ask notch2-nuc-breed        with [ticks > ( birth + notchAge )] [

    ask parent [
      set cleaved2-nuc-notch-count-value ( cleaved2-nuc-notch-count-value - 1 )
    ]

    die
  ]

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; transcribe proteins ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to transcribe-proteins
; first check condition that the second notch pathway is not inducing signaling
  ask nucleus-breed [

    set notch-transcription-rate (notch-transcription-initial-rate + cleaved-nuc-notch-count-value)
    set delta-transcription-rate (delta-transcription-initial-rate - cleaved-nuc-notch-count-value)

    ;; transcribe notch proteins
    if notch-transcription-rate >= random 100 [
      hatch-notch-breed 1 [
        set birth ticks
        set heading    (random 360)
        set color      blue
        set shape      "dot"
        set parent     myself
        set parent-who [who] of myself
      ]
    ]

    ;; transcribe delta proteins
    if delta-transcription-rate >= random 100 [
      hatch-delta-breed 1 [
        set birth      ticks
        set heading    (random 360)
        set color      red
        set shape      "dot"
        set parent     myself
        set parent-who [who] of myself
      ]
    ]
  ]

    ; if the cell has been signaled past a threshold value of nuclear notch, it begins transcriping the second notch pathway

    ask nucleus-breed [set currentNuclearNotchCnt (count notch-nuc-breed with [parent = myself])
      if currentNuclearNotchCnt >= threshold-for-second-path [
          set notch2-transcription-rate (notch2-transcription-initial-rate + cleaved2-nuc-notch-count-value)
          set delta2-transcription-rate (delta2-transcription-initial-rate - cleaved2-nuc-notch-count-value)
         ;; transcribe notch 2 proteins
        if notch2-transcription-rate >= random 100 [
          hatch-notch2-breed 1 [
            set birth ticks
            set heading    (random 360)
            set color      green
            set shape      "dot"
            set parent     myself
            set parent-who [who] of myself
          ]
        ]

        ;; transcribe delta 2 proteins
        if delta2-transcription-rate >= random 100 [
          hatch-delta2-breed 1 [
            set birth      ticks
            set heading    (random 360)
            set color      orange
            set shape      "dot"
            set parent     myself
            set parent-who [who] of myself
        ]
      ]
    ]
    ]


end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; move proteins around cellspace ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to diffuse-proteins

  ;;--------------------------------------------------
  ;; diffuse non-lipid bound components
  diffuse-cytosol-proteins
  ;;--------------------------------------------------

  ;;--------------------------------------------------
  ;; diffuse proteins on lipid surface
  diffuse-lipid-proteins
  ;;--------------------------------------------------

end


;; proteins diffuse in cytosol by moving is specfic directions
;; or randomly moving.  The lipids help keep proteins from wandering
;; beyond the cell edge.
to diffuse-cytosol-proteins

  ;; diffuse transcribed delta-breed
  ask delta-breed [
    forward unitMove * 0.5
  ]
  ask delta2-breed [
    forward unitMove * 0.5
  ]

  ;; diffuse transcribed notches
  ask notch-breed [
    forward unitMove * 0.5
  ]
  ask notch2-breed [
    forward unitMove * 0.5
  ]

end


;; proteins diffuse on the membranes by initially aligning with a
;; given lipid and then moving the the lipid on left or right
to diffuse-lipid-proteins

  let result 0

  ;; Ask lipid diffusers to move along the lipid
  ;; with equal probability of going left, right, or
  ;; remaining in the same location.

  ask lipid-breed [
    set curr-proteins nobody
  ]

  ask notch-mem-breed [

    set result (random 3)

    if result = 0 [

      set local-lipid    [left-mem]  of local-lipid
      set xcor           [xcor]      of local-lipid
      set ycor           [ycor]      of local-lipid
      set heading        [heading]   of local-lipid
    ]

    if result = 1 [

      set local-lipid    [right-mem] of local-lipid
      set xcor           [xcor]      of local-lipid
      set ycor           [ycor]      of local-lipid
      set heading        [heading]   of local-lipid
    ]

    ask local-lipid [
      set curr-proteins (turtle-set curr-proteins myself)
    ]
  ]

  ask delta-mem-breed [

    set result (random 3)

    if result = 0 [
      set local-lipid    [left-mem]  of local-lipid
      set xcor           [xcor]      of local-lipid
      set ycor           [ycor]      of local-lipid
      set heading        [heading]   of local-lipid
    ]

    if result = 1 [
      set local-lipid    [right-mem] of local-lipid
      set xcor           [xcor]      of local-lipid
      set ycor           [ycor]      of local-lipid
      set heading        [heading]   of local-lipid
    ]

    ask local-lipid [
      set curr-proteins (turtle-set curr-proteins myself)
    ]
  ]

  ask delta-mem-prime-breed [

    set result (random 3)

    if result = 0 [
      set local-lipid    [left-mem]  of local-lipid
      set xcor           [xcor]      of local-lipid
      set ycor           [ycor]      of local-lipid
      set heading        [heading]   of local-lipid
    ]

    if result = 1 [
      set local-lipid    [right-mem] of local-lipid
      set xcor           [xcor]      of local-lipid
      set ycor           [ycor]      of local-lipid
      set heading        [heading]   of local-lipid
    ]

    ask local-lipid [
      set curr-proteins (turtle-set curr-proteins myself)
    ]
  ]


  ;again replicated for the second notch signaling proteins

    ask notch2-mem-breed [

    set result (random 3)

    if result = 0 [

      set local-lipid    [left-mem]  of local-lipid
      set xcor           [xcor]      of local-lipid
      set ycor           [ycor]      of local-lipid
      set heading        [heading]   of local-lipid
    ]

    if result = 1 [

      set local-lipid    [right-mem] of local-lipid
      set xcor           [xcor]      of local-lipid
      set ycor           [ycor]      of local-lipid
      set heading        [heading]   of local-lipid
    ]

    ask local-lipid [
      set curr-proteins (turtle-set curr-proteins myself)
    ]
  ]

  ask delta2-mem-breed [

    set result (random 3)

    if result = 0 [
      set local-lipid    [left-mem]  of local-lipid
      set xcor           [xcor]      of local-lipid
      set ycor           [ycor]      of local-lipid
      set heading        [heading]   of local-lipid
    ]

    if result = 1 [
      set local-lipid    [right-mem] of local-lipid
      set xcor           [xcor]      of local-lipid
      set ycor           [ycor]      of local-lipid
      set heading        [heading]   of local-lipid
    ]

    ask local-lipid [
      set curr-proteins (turtle-set curr-proteins myself)
    ]
  ]

  ask delta2-mem-prime-breed [

    set result (random 3)

    if result = 0 [
      set local-lipid    [left-mem]  of local-lipid
      set xcor           [xcor]      of local-lipid
      set ycor           [ycor]      of local-lipid
      set heading        [heading]   of local-lipid
    ]

    if result = 1 [
      set local-lipid    [right-mem] of local-lipid
      set xcor           [xcor]      of local-lipid
      set ycor           [ycor]      of local-lipid
      set heading        [heading]   of local-lipid
    ]

    ask local-lipid [
      set curr-proteins (turtle-set curr-proteins myself)
    ]
  ]

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; additional protein manipulations ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; these are the trickiest but critical to the proper functioning
;; of the system.
to transform-proteins

  ;;-----------------------------------------------------------------
  ;;-----------------------------------------------------------------
  ;; ask lipids to pull diffusers on to the surface


  ask lipid-breed [

    ask delta-breed in-radius (lipid-distance / 1) [

      set breed          delta-mem-breed
      set xcor           [xcor]    of myself
      set ycor           [ycor]    of myself
      set heading        [heading] of myself
      set shape          "arrow"
      set mem-time       ticks

      set local-lipid myself
      ask local-lipid [
        set curr-proteins (turtle-set curr-proteins myself)
      ]
    ]

    ;;-- process transcribed notches --------------------------
    ask notch-breed in-radius (lipid-distance / 1) [

      set breed          notch-mem-breed
      set xcor           [xcor] of myself
      set ycor           [ycor] of myself
      set heading        [heading] of myself
      set shape          "arrow"
      ;set color          blue
      set local-lipid myself
      ask local-lipid [
        set curr-proteins (turtle-set curr-proteins myself)
      ]
    ]
  ]

  ;;-----------------------------------------------------------------
  ;;-----------------------------------------------------------------
  ;; Transform membrane delta to delta prime after a specific period,
  ;; if period is zero, do it autmatically.
  ifelse delta-transform-time = 0 [

    ask delta-mem-breed [
      set breed delta-mem-prime-breed
      set color pink
    ]

  ][

    let transform-tick (ticks - delta-transform-time)
    ask delta-mem-breed [
      if mem-time < transform-tick [
        set breed delta-mem-prime-breed
        set color pink
      ]
    ]
  ]

  ;;-----------------------------------------------------------------
  ;;-----------------------------------------------------------------
  ;; ask all cleaved-notch agents to diffuse a certain amount
  ask cleaved-notch-breed with [time-cleaved + indCleavedDiffTime < ticks] [

    set heading towards parent

    forward (distance parent) - (unitMove * centersomeSize) + 3

    set breed          notch-nuc-breed

    ask parent [
      set cleaved-nuc-notch-count-value ( cleaved-nuc-notch-count-value + 1 )
    ]

    set time-nuc       ticks
  ]

  ;;-----------------------------------------------------------------
  ;;-----------------------------------------------------------------
  ;; ask delta-mem-breed to laterally protect notches
  ask notch-mem-breed [ set protected false ]

  let p nobody

  ;;-----------------------------------------------------------------
  ;;-----------------------------------------------------------------
  ;; ask delta-mem-prime-breed to horizontally cleave notches
  let cntr 0
  let region-set nobody
  let ind-to-cleave nobody

  ask delta-mem-prime-breed [

    set cntr 0

    set region-set nobody

    ask local-lipid [

      if border-region != 0 [

         ask border-region [
           set region-set (turtle-set region-set curr-proteins)
         ]

         set ind-to-cleave one-of region-set with [breed = notch-mem-breed and protected = false]

         if ind-to-cleave != nobody [

           set cntr (cntr + 1)

           ask ind-to-cleave [
             set breed           cleaved-notch-breed
             set shape           "square 2"
             set color           green
             set heading towards parent

             set time-cleaved    ticks
             forward unitMove * 3

             ;; establish the time to destination for the current cleaved agent
             set indCleavedDiffTime (random-normal notch-cleaved-diffusion-time notch-cleaved-diffusion-time-signal)
           ]
         ]
      ]
    ]

    if cntr > 1 [
      print (word "number of cleaved notch is " cntr)
    ]
  ]

end

to transform-proteins2

  ;;-----------------------------------------------------------------
  ;;-----------------------------------------------------------------
  ;; ask lipids to pull diffusers on to the surface
  ask lipid-breed [

    ask delta2-breed in-radius (lipid-distance / 1) [

      set breed          delta2-mem-breed
      set xcor           [xcor]    of myself
      set ycor           [ycor]    of myself
      set heading        [heading] of myself
      set shape          "arrow"
      set mem-time       ticks

      set local-lipid myself
      ask local-lipid [
        set curr-proteins (turtle-set curr-proteins myself)
      ]
    ]

    ;;-- process transcribed notches --------------------------
    ask notch2-breed in-radius (lipid-distance / 1) [

      set breed          notch2-mem-breed
      set xcor           [xcor] of myself
      set ycor           [ycor] of myself
      set heading        [heading] of myself
      set shape          "arrow"
      ;set color          green
      set local-lipid myself
      ask local-lipid [
        set curr-proteins (turtle-set curr-proteins myself)
      ]
    ]
  ]

  ;;-----------------------------------------------------------------
  ;;-----------------------------------------------------------------
  ;; Transform membrane delta to delta prime after a specific period,
  ;; if period is zero, do it autmatically.
  ifelse delta2-transform-time = 0 [

    ask delta2-mem-breed [
      set breed delta2-mem-prime-breed
      set color orange
    ]

  ][

    let transform-tick (ticks - delta2-transform-time)
    ask delta2-mem-breed [
      if mem-time < transform-tick [
        set breed delta2-mem-prime-breed
        set color orange
      ]
    ]
  ]

  ;;-----------------------------------------------------------------
  ;;-----------------------------------------------------------------
  ;; ask all cleaved-notch agents to diffuse a certain amount
  ask cleaved2-notch-breed with [time-cleaved + indCleavedDiffTime < ticks] [

    set heading towards parent

    forward (distance parent) - (unitMove * centersomeSize) + 3

    set breed          notch2-nuc-breed

    ask parent [
      set cleaved2-nuc-notch-count-value ( cleaved2-nuc-notch-count-value + 1 )
    ]

    set time-nuc       ticks
  ]

  ;;-----------------------------------------------------------------
  ;;-----------------------------------------------------------------
  ;; ask delta-mem-breed to laterally protect notches
  ask notch2-mem-breed [ set protected false ]

  let p nobody

  ;;-----------------------------------------------------------------
  ;;-----------------------------------------------------------------
  ;; ask delta-mem-prime-breed to horizontally cleave notches
  let cntr 0
  let region-set nobody
  let ind-to-cleave nobody

  ask delta2-mem-prime-breed [

    set cntr 0

    set region-set nobody

    ask local-lipid [

      if border-region != 0 [

         ask border-region [
           set region-set (turtle-set region-set curr-proteins)
         ]

         set ind-to-cleave one-of region-set with [breed = notch2-mem-breed and protected = false]

         if ind-to-cleave != nobody [

           set cntr (cntr + 1)

           ask ind-to-cleave [
             set breed           cleaved2-notch-breed
             set shape           "square 2"
             set color           yellow
             set heading towards parent

             set time-cleaved    ticks
             forward unitMove * 3

             ;; establish the time to destination for the current cleaved agent
             set indCleavedDiffTime (random-normal notch2-cleaved-diffusion-time notch2-cleaved-diffusion-time-signal)
           ]
         ]
      ]
    ]

    if cntr > 1 [
      print (word "number of cleaved notch 2 is " cntr)
    ]
  ]

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; proceedures for ploting and storing data ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to plot-current-data

  set-current-plot "Neuron Count"
  plot neuron-cnt
  plot third-cell-cnt

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Reporting tools                           ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to-report neuron-cnt

  let neuronCnt 0

  ;;--- compute neuron count
  ask nucleus-breed [

    set currentNuclearNotchCnt (count notch-nuc-breed with [parent = myself])

    if currentNuclearNotchCnt = 0 [
      set neuronCnt (neuronCnt + 1)



    ]


  ]

  report neuronCnt


end
to-report third-cell-cnt

  let thirdCnt 0

  ;;--- compute neuron count
  ask nucleus-breed [

    set currentNuclearNotch2Cnt (count notch2-nuc-breed with [parent = myself])

    if currentNuclearNotch2Cnt = 0 [
      set thirdCnt (thirdCnt + 1)



    ]


  ]

  report thirdCnt


end

;second addition by me, collor code cells

to check-cell-line

  ask nucleus-breed [ set currentNuclearNotchCnt (count notch-nuc-breed with [parent = myself])
                      set currentNuclearNotch2Cnt (count notch2-nuc-breed with [parent = myself])

      if cell-line-overlay? [
        if currentNuclearNotchCnt = 0 and currentNuclearNotch2Cnt = 0 [
        color-cell-line-blue ]
    ] ;these are neurons, they only produce delta and notch


      if currentNuclearNotchCnt != 0 and currentNuclearNotch2Cnt = 0[
        if cell-line-overlay? [
          color-cell-line-green ]
      ] ; these are the green cells, (skin) they will produce notch and delta but are not signaled by the second notch pathway
      if currentNuclearNotchCnt = 0 and currentNuclearNotch2Cnt != 0  [
        if cell-line-overlay? [
      color-cell-line-pink]


  ]
  ]
end














;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; proceedures for generating topology ;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to layout-nucleus-breed-sheet

  let total-rows cell-row-cnt
  let total-cols cell-col-cnt
  let border-size 1
  let xborder border-size
  let yborder border-size + radius

  let row-pos 0
  let col-pos 0
  let row-cnt 0
  let col-cnt 0

  while [col-pos < total-cols] [

    ifelse col-pos = 0 [
      ;; create nucleus-breed for first column
      create-nucleus-breed total-rows [

        set   color white
        set   shape "circle"
        set   placed false

        ;; make room for a half row at the top
        setxy (radius + xborder) ( max-pycor - (radius + yborder))

      ]
    ][
      set row-cnt total-rows

      ;; create nucleus-breed for first column
      create-nucleus-breed row-cnt [

        set color    white
        set shape   "circle"
        set placed   false

        ;; make room for a half row at the top

        set col-cnt  0
        setxy (radius + xborder) ( max-pycor - (radius + yborder))

        while [col-cnt < col-pos] [

          ifelse (col-cnt mod 2) = 0 [
            set heading  60
          ][
            set heading 120
          ]

          forward diameter
          set col-cnt col-cnt + 1
        ]
      ]
    ]

    set row-pos 0

    foreach sort-by [ [?1 ?2] -> [who] of ?1 < [who] of ?2 ] (nucleus-breed with [placed = false])
    [ ?1 -> ask ?1 [

      ;; move starting column nucleus to start position
      set heading 180
      forward (row-pos * diameter)
      set row-pos row-pos + 1
      set placed true

    ] ]

    set col-pos col-pos + 1
  ]
end

;my addition, trying to color code the cells based on the cell type.



to color-cell-line-blue



  ask nucleus-breed with [currentNuclearNotchCnt = 0 and currentNuclearNotch2Cnt = 0] [
    ask patches in-radius 5.5 [ set pcolor blue]

  ]

end

to color-cell-line-green

  ask nucleus-breed with [currentNuclearNotchCnt != 0 and currentNuclearNotch2Cnt = 0] [
    ask patches in-radius 5.5 [ set pcolor 67]

  ]
end

to color-cell-line-pink

  ask nucleus-breed with [currentNuclearNotchCnt != 0 and currentNuclearNotch2Cnt != 0] [
    ask patches in-radius 5.5 [ set pcolor pink]

  ]
end














;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; misc. proceedures  ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;------------------------------------------------------
;--- generate the lipids ---------------------------
to layout-lipids

  ask nucleus-breed [

    ;--- build lipid set
    hatch-lipid-breed (lipid-density * 6) [
      set color yellow
      set shape "square"
      set parent myself
      set parent-who [who] of myself
    ]

    ;--- collect lipid proteins in agentset
    set lipid-set lipid-breed-here

    ;--- collect lipid proteins in ordered list
    let tempory-lipid-list sort lipid-set

    ;;;----------------------------------------------------------
    ;;;--- relate lipids to neighbors START-PROCESSING
    ; configure first lipid --------------------------------
    ask first tempory-lipid-list [
      set left-mem  (last   tempory-lipid-list)
      set right-mem (item 1 tempory-lipid-list)
    ]

    ; configure middle lipids --------------------------------
    let list-pos         1
    let middle-list-size (count lipid-set - 2)

    repeat middle-list-size [
      ask item list-pos tempory-lipid-list [
        set left-mem  item (list-pos - 1) tempory-lipid-list
        set right-mem item (list-pos + 1) tempory-lipid-list
      ]

      set list-pos (list-pos + 1)
    ]

    ; configure last lipid --------------------------------
    ask last tempory-lipid-list [
      set left-mem  (item  middle-list-size tempory-lipid-list)
      set right-mem (first                  tempory-lipid-list)
    ]
    ;;;--- relate lipids to neighbors   END-PROCESSING
    ;;;----------------------------------------------------------

    ;;;----------------------------------------------------------
    ;;;--- place lipid proteins       START-PROCESSING
    ; initialize nucleus-breed variables -----------------------------
    let lipid-cnt     0
    set lipid-start  -1

    ;--- initialize local variables ---------------------------
    let moveIncrement   (radius / lipid-density)
    let incrementSteps   0
    let hex-edge         0

    foreach tempory-lipid-list [ ?1 ->

      if (incrementSteps = lipid-density) [
        set hex-edge       (hex-edge + 1)
        set incrementSteps 0
      ]

      ask ?1 [

        ;;;--- define first and last lipid in nucleus
        if [lipid-start] of myself = -1 [
          ask myself [
            set lipid-start myself
          ]
        ]

        ask myself [
          set lipid-end myself
        ]

        ;;;--- move lipid to corner
        set heading (hex-edge * 60 + 30)
        forward radius

        ;;;--- move non-corner lipid along the edge
        if incrementSteps > 0 [
          set heading (heading + 120)
          forward (incrementSteps * moveIncrement)
          set heading (heading - 90)
        ]
      ]

      set incrementSteps (incrementSteps + 1)
    ]
    ;;;--- place lipid proteins        END-PROCESSING
    ;;;----------------------------------------------------------
  ]

  draw-centersome

  let region nobody
  ask lipid-breed [

    set region lipid-breed in-cone (lipid-distance * 4) 45

    if (count region) > 1 [

      set border-region region with [self != myself]

    ]
  ]

end

to draw-centersome

  let dia    (unitMove * centersomeSize * 2)
  let circum (pi * dia)
  ask nucleus-breed [
    hatch 1 [
      set color   green
      set heading 0

      forward dia / 2
      rt 90
      pd

      forward (circum / 360)
      rt 1

      while [heading != 90] [
        forward (circum / 360)
        rt 1
      ]

      die

    ]
  ]

end

;another addition attempt by me, reorganization
to swap-with-neighbor
  ask delta-breed [die]
  ask notch-breed [die]
  ask delta-mem-breed [die]
  ask notch-mem-breed [die]
  ask cleaved-notch-breed [die]
  ;ask nucleus-breed  [set currentNuclearNotchCnt (count notch-nuc-breed with [parent = myself])]
   ; if currentNuclearNotchCnt = 0 [
  ;let locat [who] nucleus-breed
    ;ask notch-nuc-breed with [parent with [currentNuclearNotchCnt = 0] ]

   ; ask delta-mem-prime-breed with [parent with [currentNuclearNotchCnt = 0] ]
   ; move-to one-of nucleus-breed with [currentNuclearNotchCnt != 0]
   ; ]


   ; if currentNuclearNotchCnt != 0 [
   ; move-to one-of nucleus-breed with [currentNuclearNotchCnt = 0]
   ; ]
end
@#$#@#$#@
GRAPHICS-WINDOW
357
10
1183
674
-1
-1
4.07
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
200
0
160
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
11
51
74
84
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
0

BUTTON
11
90
89
123
NIL
go-5000
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
2
162
164
222
current-seed
1.24636983E9
1
0
Number

INPUTBOX
2
267
162
327
notch-cleaved-diffusion-time
175.0
1
0
Number

INPUTBOX
3
364
163
424
delta-transform-time
0.0
1
0
Number

INPUTBOX
9
462
166
522
notch-transcription-initial-rate
12.0
1
0
Number

INPUTBOX
7
572
161
632
delta-transcription-initial-rate
24.0
1
0
Number

SWITCH
195
113
343
146
cell-line-overlay?
cell-line-overlay?
0
1
-1000

PLOT
1176
16
1376
166
Neuron Count
time
Neurons
0.0
5000.0
0.0
77.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

BUTTON
198
25
306
58
NIL
check-cell-line
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
1189
175
1330
208
NIL
swap-with-neighbor
NIL
1
T
TURTLE
NIL
NIL
NIL
NIL
1

INPUTBOX
166
266
321
326
notch2-cleaved-diffusion-time
225.0
1
0
Number

INPUTBOX
172
464
327
524
notch2-transcription-initial-rate
8.0
1
0
Number

INPUTBOX
176
571
331
631
delta2-transcription-initial-rate
18.0
1
0
Number

INPUTBOX
169
366
324
426
delta2-transform-time
0.0
1
0
Number

INPUTBOX
170
160
301
220
threshold-for-second-path
0.0
1
0
Number

SLIDER
181
229
353
262
notch2-cleaved-diffusion-time
notch2-cleaved-diffusion-time
0
225
225.0
25
1
NIL
HORIZONTAL

SLIDER
180
328
352
361
delta2-transform-time
delta2-transform-time
0
150
0.0
25
1
NIL
HORIZONTAL

SLIDER
181
426
354
459
notch2-transcription-initial-rate
notch2-transcription-initial-rate
8
24
8.0
2
1
NIL
HORIZONTAL

SLIDER
173
530
355
563
delta2-transcription-initial-rate
delta2-transcription-initial-rate
8
24
18.0
2
1
NIL
HORIZONTAL

INPUTBOX
99
10
188
70
rows-of-cells
3.0
1
0
Number

INPUTBOX
98
74
187
134
columns-of-cells
6.0
1
0
Number

SLIDER
2
229
169
262
notch-cleaved-diffusion-time
notch-cleaved-diffusion-time
0
225
175.0
25
1
NIL
HORIZONTAL

SLIDER
5
328
177
361
delta-transform-time
delta-transform-time
0
150
0.0
25
1
NIL
HORIZONTAL

SLIDER
3
426
177
459
notch-transcription-initial-rate
notch-transcription-initial-rate
8
24
12.0
2
1
NIL
HORIZONTAL

SLIDER
4
531
171
564
delta-transcription-initial-rate
delta-transcription-initial-rate
8
24
24.0
2
1
NIL
HORIZONTAL

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
