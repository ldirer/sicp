; rlwrap scheme --load "ch5/compiler/eceval.scm"
(load "ch4/interpreter_preload.scm")
(load "ch5/repl_controller.scm")
(load "ch5/compiler/evaluator_controller.scm")
(load "ch5/machine.scm")
(load "ch5/ex5.17.scm")
;(load "ch5/ex5.18.scm")
;; 5.11 enables a stack that tracks which register the value belonged to and refuses to restore to a different one.
;; issue with this is that if part of the assembler code *does* use that behavior on purpose, it will crash.
;(load "ch5/ex5.11.scm")
(load "ch5/stack-with-stats.scm")
(load "ch5/eceval_ops.scm")

(load "ch5/ex5.23.scm")
(load "ch5/ex5.24.scm")

(define evaluator-controller
  (append
    evaluator-controller
    ev-let-controller
    ; the safer version is the not-special-form. Less controller code written by me :).
    ev-cond-controller
;     ev-cond-controller-special-form
    )
  )


(define eceval
  ; arg1 arg2 for ex5.38 - open-coded primitives
  ; compapp from ex5.47
  (make-machine '(exp env val proc argl continue unev debug arg1 arg2 compapp)
    eceval-operations
    (append repl-controller
      evaluator-controller
      )
    )
  )
; section 5.5, 'external-entry' label in repl to start with compiled code
(set-register-contents! eceval 'flag #f)

;; requires 5.17
;(eceval 'trace-on)

; requires 5.18
;(trace-register eceval 'unev #t)
;(trace-register eceval 'exp #t)
;(trace-register eceval 'continue #t)

