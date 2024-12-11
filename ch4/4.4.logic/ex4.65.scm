(load "ch4/4.4.logic/data_jobs.scm")

(wheel ?who)
;;;; Query results:
;(wheel (warbucks oliver))
;(wheel (warbucks oliver))
;(wheel (bitdiddle ben))
;(wheel (warbucks oliver))
;(wheel (warbucks oliver))

; this also returns 4 results:
;(wheel (warbucks oliver))

; Looking at the rule definition:
;  (rule (wheel ?person)
;    (and
;      (supervisor ?middle-manager ?person)
;      (supervisor ?x ?middle-manager)
;      )
;    )
;
; 1. Unify (wheel ?who) with (wheel ?person). (?who maps to ?person).
; 2. match the and. Starts with (supervisor ?middle-manager ?person).
; This creates a stream of frames with every possible supervisor statement in the database.
; This means middle-managers/persons listed multiple times appear multiple times.
; 3. second clause of the and statement. Work on the earlier frames, will produce new frames for every assertion in the db that matches.
; This can mean no frames, but it can also mean multiple frames (in the case of (supervisor ?x ?mm) with mm=(Bitdiddle Ben), that's 3 frames.
; For Scrooge XXX that's one frame.
; total 4.


(supervisor ?one ?two)
;(supervisor ?one (Bitdiddle Ben))
;(supervisor ?middle-manager (Warbucks Oliver))

