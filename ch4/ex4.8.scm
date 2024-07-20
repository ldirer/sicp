(load "testing.scm")
(load "ch4/syntax.scm")
(load "ch4/ex4.4.scm")

(define (named-let? expr) (and (let? expr) (symbol? (cadr expr))))

;  forward to regular let, ignoring one item (the 'name' part of the named let)
(define (named-let-body expr) (let-body (cdr expr)))
(define (named-let-bindings expr) (let-bindings (cdr expr)))
(define (named-let-name expr) (cadr expr))

(define (named-let->let expr)
  ; transform the named let into a regular let like '(let ((my-function (lambda (a b) ..))) (my-function initial-a initial-b))'
  ; body of new let is the application of the function to the values defined in old (named) let.
  (let* (
          (body (named-let-body expr))
          (bindings (named-let-bindings expr))
          (variables (map let-binding-name bindings))
          (variable-values (map let-binding-value bindings))
          (let-function-name (named-let-name expr))
          (let-function (make-lambda variables body))
          (new-bindings (list (make-let-binding let-function-name let-function)))
          )
      (make-let
        new-bindings
        (list (cons let-function-name variable-values))
        )
      )
  )

; handle 'named let' on top of the regular variant
(define (let->combination expr)

  (if (named-let? expr)
    (let->combination (named-let->let expr))
    (let* (
            (body (let-body expr))
            (bindings (let-bindings expr))
            (variables (map let-binding-name bindings))
            (variable-values (map let-binding-value bindings))
            )
      (cons (make-lambda variables body) variable-values)

      )
    )
  )



(define regular-let '(let (
                            (a 1)
                            (b 2)
                            )
                       (+ a b)
                       ))
(define named-let '(let fib-iter ((a 1)
                                   (b 0)
                                   (count n))
                     (if (= count 0)
                       b
                       (fib-iter (+ a b) a (- count 1))
                       )
                     )
  )

(check-equal "regular let not seen as named" (named-let? regular-let) false)
(check-equal "named let seen as named" (named-let? named-let) true)

(named-let->let named-let)

(let->combination named-let)
;expected: ((lambda (fib-iter) (fib-iter 1 0 n)) (lambda (a b count) (if (= count 0) b (fib-iter (+ a b) a (- count 1)))))