(load "ch4/environment.scm")
(load "ch4/syntax.scm")
(load "ch4/interpreter.scm")

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

(define primitive-procedures
  (list
    (list 'car car)
    (list 'cdr cdr)
    (list 'cons cons)
    (list 'null? null?)
    ; added compared to the book
    ; apply is required to implement map?
    (list 'apply apply)
    (list '+ +)
    ; Louis Reasoner's mistake is to add map as a primitive here (does not work as expected!)
    (list 'map map)
    )
  )

(define (primitive-procedure-names)
  (map car primitive-procedures)
  )

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc))) primitive-procedures)
  )

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme (primitive-implementation proc) args)
  )
