(define (self-evaluating? expr)
  (cond
    ((number? expr) true)
    ((string? expr) true)
    ; Added compared with the book
    ; not sure if there's a reason it's not included :/
    ; note `boolean?` only works on `'#t` and `'#f`, `(boolean? 'true)` evaluates to `false` (`true` is a variable, so when it's quoted it's just a symbol)
    ((boolean? expr) true)
    ;    ((eq? expr 'true) true)
    ;    ((eq? expr 'false) true)
    (else false)
    )
  )

(define (variable? expr) (symbol? expr))

(define (quoted? expr)
  (tagged-list? expr 'quote)
  )

(define (text-of-quotation expr) (cadr expr))

;reminder: a list is a pair. (pair? my-list) is `true`.
(define (tagged-list? expr tag)
  (if (pair? expr)
    (eq? (car expr) tag)
    false
    )
  )

(define (assignment? expr)
  (tagged-list? expr 'set!)
  )

(define (assignment-variable expr) (cadr expr))
(define (assignment-value expr) (caddr expr))

(define (definition? expr)
  (tagged-list? expr 'define)
  )

(define (make-definition name value)
  (list 'define name value)
  )

; we handle two forms here:
; 1. (define var value)
; 2. (define (var parameter1 parameter2 ..) <body>)
(define (definition-variable expr)
  (if (symbol? (cadr expr))
    (cadr expr)
    ; else clause handles function definition
    (caddr expr)
    )
  )
(define (definition-value expr)
  (if (symbol? (cadr expr))
    (caddr expr)
    (make-lambda
      (cdadr expr) ; parameters
      (cddr expr)  ; body
      )
    )
  )


(define (lambda? expr) (tagged-list? expr 'lambda))
(define (lambda-parameters expr) (cadr expr))
(define (lambda-body expr) (cddr expr))

(define (make-lambda parameters body)
  ; note this is slightly different from this!
  ;  (list 'lambda parameters body)
  (cons 'lambda (cons parameters body))
  )


(define (if? expr)
  (tagged-list? expr 'if)
  )

(define (if-predicate expr)
  (cadr expr)
  )

(define (if-consequent expr)
  (caddr expr)
  )

(define (if-alternative expr)
  (if (not (null? (cdddr expr)))
    (cadddr expr)
    ; we choose to make a non-existent else clause evaluate to false.
    ; this means an if statement with a predicate evaluating to false and no alternative will evaluate to false.
    '#f
    )
  )


(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative)
  )


(define (begin? expr) (tagged-list? expr 'begin))

(define (begin-actions expr)
  (cdr expr)
  )

; the book mentions these are not intended as a data abstraction, but to make the interpreter code clearer. Ok.
(define (last-expr? seq) (null? (cdr seq)))
(define (first-expr seq) (car seq))
(define (rest-exprs seq) (cdr seq))


; convert a sequence to an expression, adding 'begin' if necessary
(define (sequence->expr seq)
  (cond
    ((null? seq) seq)
    ((last-expr? seq) (first-expr seq))
    (else (make-begin seq))
    )
  )

(define (make-begin seq) (cons 'begin seq))


; this check *must* come last: an application is any compound expression that is not one of the expression types we
; defined above.
; This feels a bit clumsy from an API perspective. When using this function, programmers need to remember that they
; have to check all other types first.
(define (application? expr) (pair? expr))

(define (operator expr) (car expr))
(define (operands expr) (cdr expr))

(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))


;derived expressions
(define (cond? expr) (tagged-list? expr 'cond))

(define (cond-clauses expr) (cdr expr))

(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else)
  )

(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))

(define (cond->if expr) (expand-clauses (cond-clauses expr)))

(define (cond-arrow-clause? clause)
  (eq? (car clause) '=>)
  )
(define (cond-arrow-clause-recipient clause) (cadr (cond-actions clause)))

(define (let? expr) (tagged-list? expr 'let))
(define (let-bindings expr) (cadr expr))
(define (let-body expr) (cddr expr))
(define (let-binding-name binding) (car binding))
(define (let-binding-value binding) (cadr binding))


(define (make-let bindings body)
  (cons 'let (cons bindings body))
  )

(define (make-let-binding name value)
  (list name value)
  )


(define (let*? expr) (tagged-list? expr 'let*))

(define (expand-clauses clauses)
  (if (null? clauses)
    '#f      ; no else clause (I guess this needs to be consistent with how we evaluate if expressions)
    (let (
           (clause (car clauses))
           (rest-clauses (cdr clauses))
           )
      (if (cond-else-clause? clause)
        (if (null? rest-clauses)
          (sequence->expr (cond-actions clause))
          (error "ELSE clause isn't last -- COND->IF" clauses)
          )
        (make-if
          (cond-predicate clause)
          (sequence->expr (cond-actions clause))
          (expand-clauses rest-clauses)
          )
        )
      )
    )
  )
