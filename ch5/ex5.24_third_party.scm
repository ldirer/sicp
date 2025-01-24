;https://eli.thegreenplace.net/2008/04/04/sicp-section-54
; interesting implementation, pretty different (considering there isn't that much room for difference!)
; does not handle the empty clauses case.
(define ev-cond-controller-special-form
  '(
     ;; Implemented explicitly as a basic special form,
     ;; without converting to a nested if
     ;;
     ev-cond
     (assign unev (op cond-clauses) (reg exp))
     ev-cond-ev-clause
     (assign exp (op first-exp) (reg unev))
     (test (op cond-else-clause?) (reg exp))
     (branch (label ev-cond-action))
     (save exp)
     (save env)
     (save unev)
     (save continue)
     ;; Setup an evaluation of the clause predicate
     (assign exp (op cond-predicate) (reg exp))
     (assign continue (label ev-cond-clause-decide))
     (goto (label eval-dispatch))

     ev-cond-clause-decide
     (restore continue)
     (restore unev)
     (restore env)
     (restore exp)
     (test (op true?) (reg val))
     (branch (label ev-cond-action))
     ev-cond-next-clause
     (assign unev (op rest-exps) (reg unev))
     (goto (label ev-cond-ev-clause)) ; loop to next clause

     ;; We get here when the clause condition was found to
     ;; be true (or it was an 'else' clause), and we want
     ;; the actions to be evaluated. The clause is in exp.
     ;; We setup a call to ev-sequence and jump to it.
     ;;
     ev-cond-action
     (assign unev (op cond-actions) (reg exp))
     (save continue)
     (goto (label ev-sequence))
     )
  )