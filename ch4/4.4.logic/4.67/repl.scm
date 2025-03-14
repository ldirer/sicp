;rlwrap scheme --load "ch4/4.4.logic/4.67/repl.scm"
;scheme --load "ch4/4.4.logic/4.67/repl.scm" < ch4/4.4.logic/ex4.67_test.scm
(load "ch4/4.4.logic/get_put.scm")
(load "ch4/4.4.logic/syntax.scm")
(load "ch4/4.4.logic/frames.scm")
(load "ch4/4.4.logic/streams.scm")
(load "ch4/4.4.logic/4.67/rules.scm")
(load "ch4/4.4.logic/match.scm")
(load "ch4/4.4.logic/store.scm")
(load "ch4/4.4.logic/4.67/eval.scm")
(load "ch4/4.4.logic/4.67/driver.scm")
(load "ch4/4.4.logic/ex4.60_helper.scm")

(define (prompt-for-input prompt)
  (newline)
  (newline)
  (display prompt)
  (newline)
  )

(query-driver-loop)
