(load "ch4/tagged_list.scm")
; code from section 4.4.4.7

(define (type exp)
  (if (pair? exp)
    (car exp)
    (error "Unknown expression TYPE" exp)))

(define (contents exp)
  (if (pair? exp)
    (cdr exp)
    (error "Unknown expression CONTENTS" exp)))


; (assert! <rule-or-assertion>)
(define (assertion-to-be-added? exp) (eq? (type exp) 'assert!))
(define (add-assertion-body exp) (car (contents exp)))


(define (empty-conjunction? exps) (null? exps))
(define (first-conjunct exps) (car exps))
(define (rest-conjuncts exps) (cdr exps))

(define (empty-disjunction? exps) (null? exps))
(define (first-disjunct exps) (car exps))
(define (rest-disjuncts exps) (cdr exps))

(define (negated-query exps) (car exps))
(define (lisp-value-predicate exps) (car exps))
(define (lisp-value-args exps) (cdr exps))


; (rule <conclusion> <body>)
(define (rule? statement)
  (tagged-list? statement 'rule))

(define (conclusion rule) (cadr rule))
(define (rule-body rule)
  (if (null? (cddr rule))
    '(always-true)
    (caddr rule))
  )


(define (query-syntax-process exp)
  (map-over-symbols expand-question-mark exp)
  )

(define (map-over-symbols proc exp)
  (cond
    ((pair? exp)
      (cons
        (map-over-symbols proc (car exp))
        (map-over-symbols proc (cdr exp))
        )
      )
    ((symbol? exp) (proc exp))
    (else exp)
    )
  )

; expand '?x into '(? x) to make it easier to answer "is this object a variable?"
(define (expand-question-mark symbol)
  (let ((chars (symbol->string symbol)))
    (if (string=? (substring chars 0 1) "?")
      (list '?
            (string->symbol (substring chars 1 (string-length chars))))
      symbol
      )
    )
  )

(define (var? exp) (tagged-list? exp '?))
(define (constant-symbol? exp) (symbol? exp))


; procedures used to build unique variable names in rule application
(define rule-counter 0)

(define (new-rule-application-id)
  (permanent-set! rule-counter (+ 1 rule-counter))
  rule-counter
  )

(define (make-new-variable var rule-application-id)
  (cons '? (cons rule-application-id (cdr var)))
  )

(define (contract-question-mark variable)
  (string->symbol
    (string-append
      "?"
      (if (number? (cadr variable))
        (string-append
          (symbol->string (caddr variable))
          "-"
          (number->string (cadr variable)))
        (symbol->string (cadr variable))
        )
      )
    )
  )

; added for convenience: allow (load "other.scm") in the logic interpreter.
(define (load? exp) (eq? (type exp) 'load))
(define (load-filename exp) (car (contents exp)))
