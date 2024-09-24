(load "ch4/environment.scm")
(load "ch4/syntax.scm")

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond
        ((null? vars) (env-loop (enclosing-environment env)))
        ((eq? var (car vars)) (if (eq? (car vals) '*unassigned*)
                                (error "accessing unassigned variable" var)
                                (car vals)
                                ))
        (else (scan (cdr vars) (cdr vals)))
        )
      )
    (cond
      ((eq? env the-empty-environment) (error "unbound variable" var))
      (else (let ((frame (first-frame env)))
              (scan (frame-variables frame) (frame-values frame))
              )
        )
      )
    )

  (env-loop env)
  )


(define (scan-out-defines body)
  ;  expr: one expression in the body
  ; collect-definitions
  ; collect-non-definitions
  ; transform collect-definitions
  ; output:
  ; let transformed-definitions
  ; let body: assignments first, non-definitions second
  (define definitions (filter definition? body))
  (define non-definitions (filter (lambda (expr) (not (definition? expr))) body))

  (define let-bindings (map (lambda (def) (make-let-binding (definition-variable def) '*unassigned*)) definitions))
  (define assignments (map (lambda (def) (make-assignment (definition-variable def) (definition-value def))) definitions))



  (make-let let-bindings (append assignments non-definitions))

  )


(define test-code
  '(
     (define u 1)
     (define v 2)
     (+ u v)
     )
)

(scan-out-defines test-code)
;Value: (let ((u *unassigned*) (v *unassigned*)) (set! u 1) (set! v 2) (+ u v))

; c. it's better to add the transform in make-procedure (as opposed to putting it inside `procedure-body`):
; 1. Separation of concerns
; 2. the transform is done once on definition. procedure-body is called every time the procedure is applied.
(define (make-procedure parameters body env) (make-procedure parameters (scan-out-defines body) env))
