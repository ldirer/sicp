; goal: add this syntax to Scheme:
; (define (f a (b lazy) c (d lazy-memo))
; ..
; )
; much more useful because backwards compatible with regular Scheme syntax.

(load "ch4/4.2.2/lazy.scm")

(define (thunk-memo? obj) (tagged-list? obj 'thunk-memo))
(define (thunk-lazy? obj) (tagged-list? obj 'thunk-lazy))
(define (thunk-expr obj) (cadr obj))
(define (thunk-env obj) (caddr obj))

(define (make-thunk thunk-type expr env)
  (list thunk-type expr env)
  )

(define (evaluated-thunk? obj) (tagged-list? obj 'evaluated-thunk))
(define (evaluated-thunk-value obj) (cadr obj))


(define (delay-it lazy-tag expr env)
  (cond
    ((eq? lazy-tag 'lazy-memo) (make-thunk 'thunk-memo expr env))
    ((eq? lazy-tag 'lazy) (make-thunk 'thunk-lazy expr env))
    (else error "invalid lazy-tag" lazy-tag)
    )
  )

(define (force-it obj)
  (cond
    ((evaluated-thunk? obj) (evaluated-thunk-value obj))
    ; need to memoize the value. I think that means we mutate obj? Have to, right? -> yes
    ; note we force recursively as well
    ((thunk-memo? obj) (let ((value (actual-value (thunk-expr obj) (thunk-env obj))))
                         (set-car! (cdr obj) value)
                         (set-car! obj 'evaluated-thunk)
                         (set-cdr! (cdr obj) '())  ; drop the environment so it can be garbage collected
                         value
                         ))
    ((thunk-lazy? obj) (actual-value (thunk-expr obj) (thunk-env obj)))
    (else obj)
    )
  )

; accommodate `define (f a (b lazy) c (d lazy-memo))`
(define (procedure-parameter-name param)
  (if (list? param)
    (car param)
    param
    )
  )
(define (procedure-parameter-lazy-tag param)
  (if (list? param)
    (cadr param)
    'reg  ; "regular"
    )
  )

(define (apply procedure arguments env)
  (cond
    ((primitive-procedure? procedure)
      ; here all arguments are strict
      (apply-primitive-procedure procedure (list-of-actual-values arguments env))
      )
    ((compound-procedure? procedure)
      (let ((proc-params (procedure-parameters procedure)))
        (eval-sequence
          (procedure-body procedure)
          (extend-environment
            (map procedure-parameter-name proc-params)
            (list-of-values-delayed-or-not (map procedure-parameter-lazy-tag proc-params) arguments env)
            (procedure-environment procedure)
            )
          )
        )
      )
    (else (error "LAZY Unknown procedure type -- APPLY LAZY" procedure))
    )
  )


(define (list-of-values-delayed-or-not lazy-tags exprs env)
  (cond
    ((no-operands? exprs) '())
    ((or (eq? (car lazy-tags) 'lazy) (eq? (car lazy-tags) 'lazy-memo))
      (cons
        (delay-it (car lazy-tags) (first-operand exprs) env)
        (list-of-values-delayed-or-not (cdr lazy-tags) (rest-operands exprs) env)
        ))
    ((eq? (car lazy-tags) 'reg)
      (cons
        (actual-value (first-operand exprs) env)
        (list-of-values-delayed-or-not (cdr lazy-tags) (rest-operands exprs) env))
      )
    (else error "unknown parameter tag" (car lazy-tags))
    )
  )
