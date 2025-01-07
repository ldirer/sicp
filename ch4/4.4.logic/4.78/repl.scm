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

(define (active? env-value)
  (and env-value (not (or (eq? env-value "0") (eq? env-value "false"))))
  )

(load "ch4/4.4.logic/ex4.75_unique.scm")
(put 'unique 'qeval uniquely-asserted)


(if (active? (get-environment-variable "SICP_LOGIC_INTERPRETER_OPTIMIZED_AND"))
  (begin
    (load "ch4/4.4.logic/ex4.76_and_optimized.scm")
    (put 'and 'qeval conjoin-optimized)
    )
  )

(if (active? (get-environment-variable "SICP_LOGIC_INTERPRETER_DELAYED_FILTERING"))
  (begin
    (load "ch4/4.4.logic/ex4.77_delayed_filtering.scm")
    (put 'not 'qeval negate)
    (put 'lisp-value 'qeval lisp-value)
    )
  )

(define (prompt-for-input prompt)
  (newline)
  (newline)
  (display prompt)
  (newline)
  )

(query-driver-loop)
