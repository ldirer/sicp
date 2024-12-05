; use logic
(load "ch4/4.4.logic/data_jobs.scm")

; compound queries:
; a. names of all people who are supervised by Ben Bitdiddle, together with their addresses
(and
  (supervisor ?name (Bitdiddle Ben))
  (address ?name ?address)
  )
; results:
;(and (supervisor (tweakit lem e) (bitdiddle ben)) (address (tweakit lem e) (boston (bay state road) 22)))
;(and (supervisor (fect cy d) (bitdiddle ben)) (address (fect cy d) (cambridge (ames street) 3)))
;(and (supervisor (hacker alyssa p) (bitdiddle ben)) (address (hacker alyssa p) (cambridge (mass ave) 78)))


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


; c. all people who are supervised by someone who is not in the computer division, together with the supervisor's name and job.

(and (supervisor ?name ?supervisor)
  (not (job ?supervisor (computer . ?x)))
  ; ah. apparently need to add this to include the information we want in the output (~like a SQL SELECT)
  (job ?supervisor ?supervisorjob)
  )
; results:
;(and (supervisor (aull dewitt) (warbucks oliver)) (not (job (warbucks oliver) (computer . ?x))) (job (warbucks oliver) (administration big wheel)))
;(and (supervisor (cratchet robert) (scrooge eben)) (not (job (scrooge eben) (computer . ?x))) (job (scrooge eben) (accounting chief accountant)))
;(and (supervisor (scrooge eben) (warbucks oliver)) (not (job (warbucks oliver) (computer . ?x))) (job (warbucks oliver) (administration big wheel)))
;(and (supervisor (bitdiddle ben) (warbucks oliver)) (not (job (warbucks oliver) (computer . ?x))) (job (warbucks oliver) (administration big wheel)))
