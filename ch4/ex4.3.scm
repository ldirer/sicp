(load "testing.scm")
(load "ch4/interpreter_rules.scm")
(load "ch4/syntax.scm")
; > Rewrite eval so that the dispatch is done
; > in data-directed style. Compare this with the data-directed
; > diﬀerentiation procedure of Exercise 2.73. (You may use the
; > car of a compound expression as the type of the expres-
; > sion, as is appropriate for the syntax implemented in this
; > section.)

(define (lookup-variable-value expr env)
  (error "variable lookup not implemented, can't lookup" expr)
  )

(define (eval expr env)
  (cond
    ; I'm using `car expr` directly but we could use a separate `type-tag` procedure to decide the type of the data.
    ; In that function we could also check for `number?, string?`, etc. and return a relevant type (then we could register functions for these too).
    ; I thought it was simpler to just leave a couple special cases here.
    ((self-evaluating? expr) expr)
    ((variable? expr) (lookup-variable-value expr env))
    (else ((get 'eval (car expr)) expr env))
    )
  )


; get/put
(define op-table (list))

(define (put op type proc)
  (set! op-table (cons (list op type proc) op-table)))

(define (get op type)

  (define (lookup op-list op type)
    (cond
      ((null? op-list) (error "not expected: " op type))
      ((and (equal? op (caar op-list)) (equal? type (cadar op-list))) (caddar op-list))
      (else (lookup (cdr op-list) op type))
      )
    )
  (lookup op-table op type)
  )


(define (install-eval)
  (define (eval-lambda expr env)
    (make-procedure (lambda-parameters expr) (lambda-body expr) env)
    )
  (define (eval-begin expr env)
    (eval-sequence (begin-actions expr) env)
    )
  (define (eval-cond expr env)
    (eval (cond->if expr) env)
    )

  (define (eval-application expr env)
    (apply
      (eval (operator expr) env)
      (list-of-values (operands expr) env)
      )
    )

  (put 'eval 'set! eval-assignment)
  (put 'eval 'set! eval-definition)
  (put 'eval 'if eval-if)
  (put 'eval 'lambda eval-lambda)
  (put 'eval 'begin eval-begin)
  (put 'eval 'cond eval-cond)
  (put 'eval 'call eval-application)

  (put 'eval 'quote (lambda (expr env) (text-of-quotation expr)))
  )
(install-eval)
