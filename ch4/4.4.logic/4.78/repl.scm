(load "ch4/4.4.logic/4.78/utils.scm")
(load "ch4/4.4.logic/4.78/get_put.scm")
(load "ch4/4.4.logic/4.78/syntax.scm")
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


; The plan was to run this inside the ambeval driver loop.
; So we feed all this code to the ambeval repl. It kinda looks like it works at first.
; But:
; 1. It immediately says: "There are no more values of (query-driver-loop)"
; We need to call the function again to get a new query prompt.
; 2. It *backtracked* all changes made to global structures like THE-RULES and THE-ASSERTIONS as part of the 'load' statements.
; So the two lists are empty and that defeats the point :).

; The issue is that these two statements sent to the logic interpreter:
; (load "ch4/4.4.logic/data_jobs.scm")
; (job ?x (computer wizard))
; Are seen as part of two *different* ambeval 'problems'.
; I needed to remember about `permanent-set!`, it lets us persist the effect of `assert!` statements :).

; The original plan was ultimately mostly successful: this loop ran inside the ambeval repl.
(query-driver-loop)
