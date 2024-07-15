(load "ch4/ex4.6.scm")

(define (make-let bindings body)
  (cons 'let (cons bindings body))
  )

(define (make-let* bindings body)
  (cons 'let* (cons bindings body))
  )

(define (let*->nested-lets expr)
  (define bindings (let-bindings expr))
  (define body (let-body expr))
  (if (null? bindings)
    ; this sometimes adds an unnecessary 'begin'... But we don't want to return a sequence.
    ; an alternative would be to terminate recursion when there is just one binding left.
    ; then we could return a plain '(make-let (car binding) body)'.
    ; It's fine with the begin though, and the code is shorter.
    ; a let without bindings creates a lambda anyways so it's not really better.
    (sequence->expr body)
    (make-let
      (list (car bindings))
      (list (let*->nested-lets (make-let* (cdr bindings) body)))
      )

    )
  )



(define expr '(let* (
                      (x 3)
                      (y (+ x 2))
                      (z (+ x y 5))
                      )
                (* x z)
                ))
(let*->nested-lets expr)


(define expr '(let* (
                      (x 3)
                      (y (+ x 2))
                      (z (+ x y 5))
                      )
                (* x z)
                y
                ))
(let*->nested-lets expr)
; expected:
;Value: (let ((x 3)) (let ((y (+ x 2))) (let ((z (+ x y 5))) (begin (* x z) y))))

(define (install-let*)
  ; to answer "must we explictly expand letù in terms of non-derived expressions?"
  ; no, this is sufficient, `eval` will call itself recursively as needed (converting `let` into lambdas, then evaluating lambdas).
  (put 'eval 'let* (lambda (expr env) (eval (let*->nested-lets expr) env)))
  )
