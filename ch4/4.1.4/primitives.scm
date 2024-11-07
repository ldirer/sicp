(load "ch4/environment.scm")
(define (setup-environment)
  (let ((initial-env
          (extend-environment (primitive-procedure-names)
            (primitive-procedure-objects)
            the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    (define-variable! 'nil (list) initial-env)
    initial-env
    ))

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive)
  )

(define (primitive-implementation proc) (cadr proc))

(define (get-primitive-procedures)
  (list
    (list 'car car)
    (list 'cdr cdr)
    (list 'cons cons)
    (list 'null? null?)
    ; added compared to the book
    ; apply is required to implement map?
    ; -> a bit confused by this, with imports `apply` might not be the builtin one but our custom function
    ; --> yes, we want the custom function here. As first argument we will pass it one of our 'procedure objects.
    ; The builtin apply cannot handle that.
    (list 'apply apply)
    (list '+ +)
    (list '* *)
    (list '- -)
    (list '/ /)
    (list '< <)
    (list '<= <=)
    (list '> >)
    (list '>= >=)
    (list 'display display)
    (list 'newline newline)
    ; Louis Reasoner's mistake is to add map as a primitive here (does not work as expected!)
    ; We could do it with a custom `map` definition that handles our typed objects.
;    (list 'map map)
    )
  )

(define (primitive-procedure-names)
  (map car (get-primitive-procedures))
  )

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc))) (get-primitive-procedures))
  )

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme (primitive-implementation proc) args)
  )
