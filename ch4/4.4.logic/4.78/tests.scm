; use logic
; Ran with:
; cat ch4/4.4.logic/4.78/repl.scm ch4/4.4.logic/4.78/tests.scm - | scheme --load "ch4/4.3.3.amb/repl.scm"
; This is not the ideal workflow. Every time a logic query finishes (as an amb problem), we need to restart the query-driver-loop.
; So not all instructions in this file are interpreted by the same interpreter :)
; They are all handled by the logic interpreter, except (query-driver-loop) that will be sent as input at a time when the ambeval
; interpreter expects a new problem.
; CAVEAT: this expects the driver to print all results without the user having to manually type 'try-again'.
; it's just a lot more convenient when scripting it like this, the (query-driver-loop) calls rely on that.

; based on ex4.56
(load "ch4/4.4.logic/data_jobs.scm")

; compound queries:
; a. names of all people who are supervised by Ben Bitdiddle, together with their addresses
(and
  (supervisor ?name (Bitdiddle Ben))
  (address ?name ?address)
  )

;try-again
;try-again
;try-again


; results:
;(and (supervisor (tweakit lem e) (bitdiddle ben)) (address (tweakit lem e) (boston (bay state road) 22)))
;(and (supervisor (fect cy d) (bitdiddle ben)) (address (fect cy d) (cambridge (ames street) 3)))
;(and (supervisor (hacker alyssa p) (bitdiddle ben)) (address (hacker alyssa p) (cambridge (mass ave) 78)))


(query-driver-loop)
; b. all people whose salary is less than Ben Bitdiddle's, toegether with their salary and Ben Bitdiddle's salary
(and
  (salary (Bitdiddle Ben) ?ben)
  (salary ?person ?other)
  (lisp-value > ?ben ?other)
  )
; results:
;(and (salary (bitdiddle ben) 60000) (salary (aull dewitt) 25000) (lisp-value > 60000 25000))
;(and (salary (bitdiddle ben) 60000) (salary (cratchet robert) 18000) (lisp-value > 60000 18000))
;(and (salary (bitdiddle ben) 60000) (salary (reasoner louis) 30000) (lisp-value > 60000 30000))
;(and (salary (bitdiddle ben) 60000) (salary (tweakit lem e) 25000) (lisp-value > 60000 25000))
;(and (salary (bitdiddle ben) 60000) (salary (fect cy d) 35000) (lisp-value > 60000 35000))
;(and (salary (bitdiddle ben) 60000) (salary (hacker alyssa p) 40000) (lisp-value > 60000 40000))


(query-driver-loop)
; sanity check - looks ok. The bug is in my negate function.
;(job ?supervisor (computer . ?x))

; c. all people who are supervised by someone who is not in the computer division, together with the supervisor's name and job.
(and (supervisor ?name ?supervisor)
  (not (job ?supervisor (computer . ?x)))
  (job ?supervisor ?supervisorjob)
  )
; results:
;(and (supervisor (aull dewitt) (warbucks oliver)) (not (job (warbucks oliver) (computer . ?x))) (job (warbucks oliver) (administration big wheel)))
;(and (supervisor (cratchet robert) (scrooge eben)) (not (job (scrooge eben) (computer . ?x))) (job (scrooge eben) (accounting chief accountant)))
;(and (supervisor (scrooge eben) (warbucks oliver)) (not (job (warbucks oliver) (computer . ?x))) (job (warbucks oliver) (administration big wheel)))
;(and (supervisor (bitdiddle ben) (warbucks oliver)) (not (job (warbucks oliver) (computer . ?x))) (job (warbucks oliver) (administration big wheel)))

; \o/ \o/
