(load "ch4/interpreter_rules.scm")

; eval/apply
(define (eval expr env)
  (cond
    ((self-evaluating? expr) expr)
    ((variable? expr) (lookup-variable-value expr env))
    ((quoted? expr) (text-of-quotation expr))
    ((assignment? expr) (eval-assignment expr env))
    ((definition? expr) (eval-definition expr env))
    ((if? expr) (eval-if expr env))
    ((lambda? expr) (make-procedure (lambda-parameters expr) (lambda-body expr) env))
    ((begin? expr) (eval-sequence (begin-actions expr) env))
    ((cond? expr) (eval (cond->if expr) env))
    ((application? expr)
      (apply
        (eval (operator expr) env)
        (list-of-values (operands expr) env)
        )
      )
    (else (error "Unknown expression type -- EVAL" expr))
    )
  )


(define (apply procedure arguments)
  (cond
    ((primitive-procedure? procedure)
      (apply-primitive-procedure procedure arguments)
      )
    ; compound procedure = not a builtin (~~)
    ((compound-procedure? procedure)
      (eval-sequence
        (procedure-body procedure)
        (extend-environment
          (procedure-parameters procedure)
          arguments
          (procedure-environment procedure)
          )
        )
      )
    (else (error "Unknown procedure type -- APPLY" procedure))
    )
  )
