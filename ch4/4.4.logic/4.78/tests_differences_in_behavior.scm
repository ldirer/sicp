; use logic
; cat ch4/4.4.logic/4.78/repl.scm ch4/4.4.logic/4.78/tests_differences_in_behavior.scm - | scheme --load "ch4/4.3.3.amb/repl.scm"
(load "ch4/4.4.logic/data_jobs.scm")


; I'm not sure what the differences in behavior will be...
; No interleaving of results in this one. That's one I can think of.
; It does have implications for infinite sets of results! And makes the streams interpreter more appealing.

(or
  (job ?name (computer . ?x))
  (job ?name (accounting . ?y))
  )

; With the ambeval based interpreter, all 'computer' results come first:
;(or (job (reasoner louis) (computer programmer trainee)) (job (reasoner louis) (accounting . ?y)))
;(or (job (tweakit lem e) (computer technician)) (job (tweakit lem e) (accounting . ?y)))
;(or (job (fect cy d) (computer programmer)) (job (fect cy d) (accounting . ?y)))
;(or (job (hacker alyssa p) (computer programmer)) (job (hacker alyssa p) (accounting . ?y)))
;(or (job (bitdiddle ben) (computer wizard)) (job (bitdiddle ben) (accounting . ?y)))
;(or (job (cratchet robert) (computer . ?x)) (job (cratchet robert) (accounting scrivener)))
;(or (job (scrooge eben) (computer . ?x)) (job (scrooge eben) (accounting chief accountant)))

; With the original logic interpreter, results are interleaved:
;(or (job (reasoner louis) (computer programmer trainee)) (job (reasoner louis) (accounting . ?y)))
;(or (job (cratchet robert) (computer . ?x)) (job (cratchet robert) (accounting scrivener)))
;(or (job (tweakit lem e) (computer technician)) (job (tweakit lem e) (accounting . ?y)))
;(or (job (scrooge eben) (computer . ?x)) (job (scrooge eben) (accounting chief accountant)))
;(or (job (fect cy d) (computer programmer)) (job (fect cy d) (accounting . ?y)))
;(or (job (hacker alyssa p) (computer programmer)) (job (hacker alyssa p) (accounting . ?y)))
;(or (job (bitdiddle ben) (computer wizard)) (job (bitdiddle ben) (accounting . ?y)))
