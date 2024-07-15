(load "ch4/syntax.scm")
(load "ch4/ex4.4.scm")


(define (let->combination expr)
  (define variables (map let-binding-name (let-bindings expr)))
  (define variable-values (map let-binding-value (let-bindings expr)))
  (define body (let-body expr))
  (cons (make-lambda variables body) variable-values)
  )

(define (install-let)
  (put
    'eval 'let
    (lambda (expr env) (eval (let->combination expr) env))
    )
  )
(install-let)


(let->combination '(let (
                          (a 1)
                          (b 2)
                          )
                     (+ a b)
                     ))
; test with multiple expressions in body
(let->combination '(let (
                          (a 1)
                          (b 2)
                          )
                     (+ a b)
                     'ok
                     ))
; expected: ;Value: ((lambda (a b) (+ a b) (quote ok)) 1 2)

