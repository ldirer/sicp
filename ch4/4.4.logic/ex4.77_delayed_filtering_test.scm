(load "ch4/4.4.logic/data_jobs.scm")
(and
  (job ?p (computer wizard))
  (not (supervisor (Bitdiddle Ben) ?p))
  )

; correct
;;;; Query results:
;(and (job (bitdiddle ben) (computer wizard)) (not (supervisor (bitdiddle ben) (bitdiddle ben))))

; incorrect before exercise 4.77 - no results.
; Expected with ex4.77:
;;;; Query results:
;(and (not (supervisor (bitdiddle ben) (bitdiddle ben))) (job (bitdiddle ben) (computer wizard)))
; \o/
(and
  (not (supervisor (Bitdiddle Ben) ?p))
  (job ?p (computer wizard))
  )


(not (supervisor (Bitdiddle Ben) ?p))
; expected: no results


; similarly, these two queries should give semantically identical results with ex4.77 (and clauses swapped)
(and (salary (Bitdiddle Ben) ?ben-sal) (salary ?name ?sal) (lisp-value < ?sal ?ben-sal))

(and (salary (Bitdiddle Ben) ?ben-sal) (lisp-value < ?sal ?ben-sal) (salary ?name ?sal))


; multiple not/lisp-value
(and
  (salary (Bitdiddle Ben) ?ben-sal)
  (not (job ?name (Computer Programmer)))
  (lisp-value < ?sal ?ben-sal)
  (salary ?name ?sal)
  )
; expected:
;(and (salary (bitdiddle ben) 60000) (not (job (aull dewitt) (computer programmer))) (lisp-value < 25000 60000) (salary (aull dewitt) 25000))
;(and (salary (bitdiddle ben) 60000) (not (job (cratchet robert) (computer programmer))) (lisp-value < 18000 60000) (salary (cratchet robert) 18000))
;(and (salary (bitdiddle ben) 60000) (not (job (reasoner louis) (computer programmer))) (lisp-value < 30000 60000) (salary (reasoner louis) 30000))
;(and (salary (bitdiddle ben) 60000) (not (job (tweakit lem e) (computer programmer))) (lisp-value < 25000 60000) (salary (tweakit lem e) 25000))



