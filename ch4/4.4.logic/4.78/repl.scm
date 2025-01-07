(load "ch4/4.4.logic/get_put.scm")
(load "ch4/4.4.logic/syntax.scm")
(load "ch4/4.4.logic/frames.scm")
(load "ch4/4.4.logic/4.78/rules.scm")
(load "ch4/4.4.logic/4.78/match.scm")
(load "ch4/4.4.logic/4.78/store.scm")
(load "ch4/4.4.logic/4.78/eval.scm")
(load "ch4/4.4.logic/4.78/driver.scm")


(define (prompt-for-input prompt)
  (newline)
  (newline)
  (display prompt)
  (newline)
  )

(query-driver-loop)
