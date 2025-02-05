(load "ch5/compiler/ex5.39_lexical_addressing.scm")

(define the-empty-compiler-environment '())
(define (make-compiler-frame vars) vars)

(define (first-compiler-frame env) (car env))
(define (enclosing-compiler-environment env) (cdr env))


(define (extend-compiler-environment vars base-env)
  (cons (make-compiler-frame vars) base-env)
  )


;; return a lexical address for var, or 'not-found
(define (find-variable var comp-env)

  ;; the 'on-found' continuation passed as argument will get both frame and displacement number
  (define (env-loop env frame-number on-found)
    (define (scan vars displacement-number)
      (cond
        ((null? vars) (env-loop (enclosing-compiler-environment env) (+ frame-number 1) on-found))
        ((eq? (car vars) var) (on-found frame-number displacement-number))
        (else (scan (cdr vars) (+ displacement-number 1)))
        )
      )

    (cond
      ((eq? env the-empty-compiler-environment) 'not-found)
      (else (scan (first-compiler-frame env) 0))
      )
    )
  (env-loop comp-env 0 make-lexical-address)
  )