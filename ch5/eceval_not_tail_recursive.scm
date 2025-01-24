; rlwrap scheme --load "ch5/eceval.scm"
(load "ch4/interpreter_preload.scm")
(load "ch5/repl_controller.scm")
(load "ch5/evaluator_controller.scm")
(load "ch5/machine.scm")
(load "ch5/stack-with-stats.scm")
(load "ch5/eceval_ops.scm")

(define (no-more-exps? seq) (null? seq))
(define eceval-operations (cons (list 'no-more-exps? no-more-exps?) eceval-operations))
(define evaluator-controller
  (append
    dispatch-controller
    self-ev-controller
    ev-application-controller
    apply-controller
    ev-sequence-controller-not-tail-recursive
    conditional-controller
    assignment-controller
    definition-controller
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

(start eceval)