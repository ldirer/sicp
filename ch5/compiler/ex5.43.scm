(load "ch4/syntax.scm")
; copied from ex4.16, but there were a couple bugs...
; empty let, *unassigned* was missing a quote so interpreted as a variable, and finally the resulting let was not wrapped in a list (a procedure body should be an expression sequence).
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

  (define let-bindings (map (lambda (def) (make-let-binding (definition-variable def) ''*unassigned*)) definitions))
  (define assignments (map (lambda (def) (make-assignment (definition-variable def) (definition-value def))) definitions))

  ; make sure we do not add an empty 'let' if there are no defines
  (if (null? definitions)
    non-definitions
    ; output a sequence of expressions so it can be seen as the body of a function
    (list (make-let let-bindings (append assignments non-definitions)))
    )
  )
