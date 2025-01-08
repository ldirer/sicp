; use logic
; cat ch4/4.4.logic/4.78/repl.scm ch4/4.4.logic/4.78/tests_rules.scm - | scheme --load "ch4/4.3.3.amb/repl.scm"
(load "ch4/4.4.logic/data_jobs.scm")

; more tests: generating patterns with rules
(append-to-form ?x ?y (a b c d))
;;;; Query results:
;(append-to-form (a b c d) () (a b c d))
;(append-to-form (a b c) (d) (a b c d))
;(append-to-form (a b) (c d) (a b c d))
;(append-to-form (a) (b c d) (a b c d))
;(append-to-form () (a b c d) (a b c d))
