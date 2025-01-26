; rlwrap scheme --load "ch5/eceval.scm"
(load "ch4/interpreter_preload.scm")
(load "ch5/repl_controller_normal.scm")
(load "ch5/ex5.25_normal_order.scm")
(load "ch5/machine.scm")
(load "ch5/ex5.17.scm")
;(load "ch5/ex5.18.scm")
;; 5.11 enables a stack that tracks which register the value belonged to and refuses to restore to a different one.
;; issue with this is that if part of the assembler code *does* use that behavior on purpose, it will crash.
;(load "ch5/ex5.11.scm")
(load "ch5/stack-with-stats.scm")
(load "ch5/eceval_ops.scm")

(load "ch5/ex5.23.scm")

(define evaluator-controller
  (append
    evaluator-controller
    ev-let-controller
    ev-cond-controller
    )
  )


(define eceval
  (make-machine '(exp env val proc argl continue unev)
    eceval-operations
    (append repl-controller
      evaluator-controller
      )
    )
  )

;; requires 5.17
;(eceval 'trace-on)

; requires 5.18
;(trace-register eceval 'unev #t)
;(trace-register eceval 'exp #t)
;(trace-register eceval 'continue #t)

(start eceval)

