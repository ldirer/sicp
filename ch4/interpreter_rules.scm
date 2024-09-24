; this is basically map eval exprs, except exprs is not a 'simple' list here
; done this way to avoid using map and make it clear the interpreter does not need it.
(define (list-of-values exprs env)
  (if (no-operands? exprs)
    '()
    (cons
      (eval (first-operand exprs) env)
      (list-of-values (rest-operands exprs) env)
      )
    )
  )


(define (eval-if expr env)
  (if
    (true? (eval (if-predicate expr) env))
    (eval (if-consequent expr) env)
    (eval (if-alternative expr) env)
    )
  )

(define (eval-sequence exprs env)
  (cond
    ((last-expr? exprs) (eval (first-expr exprs) env))
    (else
      (eval (first-expr exprs) env)
      (eval-sequence (rest-exprs exprs) env)
      )
    )
  )

(define (eval-assignment expr env)
  (set-variable-value!
    (assignment-variable expr)
    (eval (assignment-value expr) env)
    env
    )
  'ok
  )

(define (eval-definition expr env)
  (define-variable!
    (definition-variable expr)
    (eval (definition-value expr) env)
    env
    )
  'ok
  )

;(define (procedure-parameters procedure) ...)
;(define (procedure-arguments procedure) ...)


(define (true? x) (not (eq? x false)))
(define (false? x) (eq? x false))


; copied from ex4.6
(define (let->combination expr)
  (define variables (map let-binding-name (let-bindings expr)))
  (define variable-values (map let-binding-value (let-bindings expr)))
  (define body (let-body expr))
  (cons (make-lambda variables body) variable-values)
  )

(define (eval-let expr env) (eval (let->combination expr) env))

; copied from ex4.20
(define (letrec->let expr)
  (define bindings (letrec-bindings expr))
  (define body (letrec-body expr))

  (define binding-names (map letrec-binding-name bindings))
  (define binding-values (map letrec-binding-value bindings))

  (define let-bindings (map (lambda (binding) (make-let-binding (letrec-binding-name binding) ''*unassigned*)) bindings))
  (define assignments (map (lambda (binding) (make-assignment (letrec-binding-name binding) (letrec-binding-value binding))) bindings))

  (make-let let-bindings (append assignments body))
  )

(define (eval-letrec expr env) (eval (letrec->let expr) env))
