; original version
; whether expressions (operands) in exprs are evaluated left to right or right to left depends on how the call to cons
; evaluates its arguments.
(define (list-of-values exprs env)
  (cond
    ((no-operands? exprs) '())
    (else (cons
            (eval (first-operand exprs) env)
            (list-of-values (rest-operands exprs) env)
            ))
    )
  )

; make sure exprs are always evaluated left to right
(define (list-of-values-ltr exprs env)
  (cond
    ((no-operands? exprs) '())
    (else
      (let (
             (first-arg (eval (first-operand exprs) env))
             (rest-args (list-of-values-ltr (rest-operands exprs) env))
             )
        (cons first-arg rest-args)
        )
      )
    )
  )
; make sure exprs are always evaluated right to left
(define (list-of-values-rtl exprs env)
  (cond
    ((no-operands? exprs) '())
    (else
      (let (
             (rest-args (list-of-values-rtl (rest-operands exprs) env))
             (first-arg (eval (first-operand exprs) env))
             )
        (cons first-arg rest-args)
        )
      )
    )
  )
