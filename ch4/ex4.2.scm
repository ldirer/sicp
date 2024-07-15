
; a.
; > Louis Reasoner plans to reorder the `cond` clauses in `eval` so that the clause for proceedure applications appears before the clause for assignments [...]
; Don't do it Louis!
; The `application?` procedure expects that all other cases have been checked first.
; `(define x 3) would be interpreted as the application of `define` on operands `x` and `3`.
; Then `define` would be interpreted as a variable. Not found, crash.


; b. We can make `application?` more 'independent' by changing the syntax.
; using `(call factorial 3)` instead of `(factorial 3)`.


(define (application? expr)
  (tagged-list? expr 'call)
  )
(define (operator expr) (cadr expr))
(define (operands expr) (cddr expr))

