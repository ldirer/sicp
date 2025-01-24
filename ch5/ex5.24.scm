; on top of this, I added a case to the eval-dispatch controller and a couple new primitive operations.
(define ev-cond-controller-special-form
  '(
     ev-cond
     (save continue)
     (save env)

     ; assign clauses to unev
     ; iterate until unev empty
     ; when empty return false
     ; if else clause or clause predicate evaluates to true: run actions
     (assign unev (op cond-clauses) (reg exp))
     cond-loop
     (test (op no-cond-clauses?) (reg unev))
     (branch (label out-of-clauses))
     (assign exp (op cond-clauses-first) (reg unev))
     (test (op cond-else-clause?) (reg exp))                         ; cond-else-clause? takes the full clause as argument
     (branch (label cond-eval-actions))
     ; evaluate predicate
     (assign exp (op cond-predicate) (reg exp))
     (save env)
     (save unev)
     (assign continue (label cond-after-eval-predicate))
     (goto (label eval-dispatch))

     cond-after-eval-predicate
     (restore unev)
     (restore env)
     (test (op true?) (reg val))
     (branch (label cond-eval-actions))
     ; move on to next clause
     (assign unev (op cond-clauses-rest) (reg unev))
     (goto (label cond-loop))

     cond-eval-actions
     ; get again the clause whose predicate evaluated to true, and get its actions.
     (assign exp (op cond-clauses-first) (reg unev))
     (assign unev (op cond-actions) (reg exp))
     (restore env)
     ; ev sequence expects continue to be _on the stack_, so we don't restore continue here.
     ; (restore continue)
     ; (save continue)
     (goto (label ev-sequence))

     out-of-clauses
     (restore env)
     (restore continue)
     (assign val (const #f))
     (goto (reg continue))
     )
  )