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



