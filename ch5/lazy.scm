; copied from chapter 4, not much remains.
; The rest is controller code, specifically anything that needed to call `eval` directly or indirectly had to be.
(define (thunk? obj) (tagged-list? obj 'thunk))
(define (thunk-expr obj) (cadr obj))
(define (thunk-env obj) (caddr obj))

(define (evaluated-thunk? obj) (tagged-list? obj 'evaluated-thunk))
(define (evaluated-thunk-value obj) (cadr obj))

(define (delay-it expr env)
  (list 'thunk expr env)
  )


; I ended up rewriting this in controller code instead of using this as an operation (which would be totally fine).
(define (list-of-values-delayed exprs env)
  (cond
    ((no-operands? exprs) '())
    (else (cons
            (delay-it (first-operand exprs) env)
            (list-of-values-delayed (rest-operands exprs) env)))
    )
  )

