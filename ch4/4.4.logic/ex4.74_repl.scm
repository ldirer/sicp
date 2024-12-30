(load "ch4/4.4.logic/get_put.scm")
(load "ch4/4.4.logic/syntax.scm")
(load "ch4/4.4.logic/frames.scm")
(load "ch4/4.4.logic/streams.scm")
(load "ch4/4.4.logic/rules.scm")
(load "ch4/4.4.logic/match.scm")
(load "ch4/4.4.logic/store.scm")
(load "ch4/4.4.logic/eval.scm")
(load "ch4/4.4.logic/driver.scm")
(load "ch4/4.4.logic/ex4.60_helper.scm")

(load "ch4/4.4.logic/ex4.74.scm")

(put 'lisp-value 'qeval lisp-value)

(define (prompt-for-input prompt)
  (newline)
  (newline)
  (display prompt)
  (newline)
  )

(query-driver-loop)
