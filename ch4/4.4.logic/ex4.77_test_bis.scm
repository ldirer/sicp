(load "ch4/4.4.logic/data_jobs.scm")

(and (not (job ?x (computer programmer)))
  (supervisor ?x ?y))
; expected correct results (with ex4.77)
;(and (not (job (aull dewitt) (computer programmer))) (supervisor (aull dewitt) (warbucks oliver)))
;(and (not (job (cratchet robert) (computer programmer))) (supervisor (cratchet robert) (scrooge eben)))
;(and (not (job (scrooge eben) (computer programmer))) (supervisor (scrooge eben) (warbucks oliver)))
;(and (not (job (bitdiddle ben) (computer programmer))) (supervisor (bitdiddle ben) (warbucks oliver)))
;(and (not (job (reasoner louis) (computer programmer))) (supervisor (reasoner louis) (hacker alyssa p)))
;(and (not (job (tweakit lem e) (computer programmer))) (supervisor (tweakit lem e) (bitdiddle ben)))


; testing for nested nots: should not change results
(and (supervisor ?x ?y) (not (not (not (job ?x (computer programmer))))))
(and (not (not (not (job ?x (computer programmer))))) (supervisor ?x ?y))

