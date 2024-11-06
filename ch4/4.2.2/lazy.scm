(load "ch4/interpreter_preload.scm")
(load "ch4/tagged_list.scm")
(load "ch4/environment.scm")
(load "ch4/syntax.scm")
(load "ch4/interpreter_rules.scm")

; eval/apply
(define (eval expr env)
  (cond
    ((self-evaluating? expr) expr)
    ((variable? expr) (lookup-variable-value expr env))
    ((quoted? expr) (text-of-quotation expr))
    ((assignment? expr) (eval-assignment expr env))
    ((definition? expr) (eval-definition expr env))
    ((let? expr) (eval-let expr env))
    ((letrec? expr) (eval-letrec expr env))
    ((if? expr) (eval-if expr env))
    ((lambda? expr) (make-procedure (lambda-parameters expr) (lambda-body expr) env))
    ((begin? expr) (eval-sequence (begin-actions expr) env))
    ((cond? expr) (eval (cond->if expr) env))
    ((application? expr)
      (begin
        (apply
          (actual-value (operator expr) env)
          (operands expr)
          env
          )
        ))
    (else (error "Unknown expression type -- EVAL" expr))
    )
  )


(define (thunk? obj) (tagged-list? obj 'thunk))
(define (thunk-expr obj) (cadr obj))
(define (thunk-env obj) (caddr obj))

(define (evaluated-thunk? obj) (tagged-list? obj 'evaluated-thunk))
(define (evaluated-thunk-value obj) (cadr obj))


(define (delay-it expr env)
  (list 'thunk expr env)
  )

(define (force-it obj)
  (cond
    ((evaluated-thunk? obj) (evaluated-thunk-value obj))
    ; need to memoize the value. I think that means we mutate obj? Have to, right? -> yes
    ; note we force recursively as well
    ((thunk? obj) (let ((value (actual-value (thunk-expr obj) (thunk-env obj))))
                    (set-car! (cdr obj) value)
                    (set-car! obj 'evaluated-thunk)
                    (set-cdr! (cdr obj) '())  ; drop the environment so it can be garbage collected
                    value
                    ))
    (else obj)
    )
  )


; whenever we want to eval + 'unthunk' something recursively
(define (actual-value expr env)
  (force-it (eval expr env))
  )


(define (apply procedure arguments env)
  (cond
    ((primitive-procedure? procedure)
      ; here all arguments are strict
      (apply-primitive-procedure procedure (list-of-actual-values arguments env))
      )
    ((compound-procedure? procedure)
      (eval-sequence
        (procedure-body procedure)
        (extend-environment
          (procedure-parameters procedure)
          (list-of-values-delayed arguments env)
          (procedure-environment procedure)
          )
        )
      )
    (else (error "LAZY Unknown procedure type -- APPLY LAZY" procedure))
    )
  )


(define (list-of-actual-values exprs env)
  ; remember we could be using map, this is to show we can do without the builtins
  (cond
    ((no-operands? exprs) '())
    (else (cons
            (actual-value (first-operand exprs) env)
            (list-of-actual-values (rest-operands exprs) env)))

    )
  )
(define (list-of-values-delayed exprs env)
  (cond
    ((no-operands? exprs) '())
    (else (cons
            (delay-it (first-operand exprs) env)
            (list-of-values-delayed (rest-operands exprs) env)))

    )
  )


(define (eval-if expr env)
  (if
    (true? (actual-value (if-predicate expr) env))
    (eval (if-consequent expr) env)
    (eval (if-alternative expr) env)
    )
  )
