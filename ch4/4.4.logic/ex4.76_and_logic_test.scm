(load "ch4/4.4.logic/data_jobs.scm")


(and
  (address ?p (?town . ?x))
  (job ?p (computer ?y))
  )
; expected results:
;;;; Query results:
;(and (address (tweakit lem e) (boston (bay state road) 22)) (job (tweakit lem e) (computer technician)))
;(and (address (fect cy d) (cambridge (ames street) 3)) (job (fect cy d) (computer programmer)))
;(and (address (hacker alyssa p) (cambridge (mass ave) 78)) (job (hacker alyssa p) (computer programmer)))
;(and (address (bitdiddle ben) (slumerville (ridge road) 10)) (job (bitdiddle ben) (computer wizard)))


(and
  (address ?p (?town . ?x))
  (noresult ?p (computer ?y))
  )
