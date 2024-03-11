;d. In this simple algebraic manipulator the type of an
;expression is the algebraic operator that binds it to-
;gether. Suppose, however, we indexed the procedures
;in the opposite way, so that the dispatch line in deriv
;looked like
;((get (operator exp) 'deriv) (operands exp) var)
;What corresponding changes to the derivative system
;are required?

; we only need to change the way the deriv variants are registered.
; original procedure from section 2.3.2
;(define (deriv exp var)
;  (cond ((number? exp) 0)
;    ((variable? exp)
;      (if (same-variable? exp var) 1 0))
;    ((sum? exp)
;      (make-sum (deriv (addend exp) var)
;        (deriv (augend exp) var)))
;
;    ((product? exp)
;      (make-sum (make-product
;                  (multiplier exp)
;                  (deriv (multiplicand exp) var))
;        (make-product
;          (deriv (multiplier exp) var)
;          (multiplicand exp))))
;    ;⟨more rules can be added here⟩
;    (else (error "unknown expression type:
;DERIV" exp))))


; rewritten with dispatch
(define (deriv exp var)
  (cond ((number? exp) 0)
    ((variable? exp) (if (same-variable? exp var) 1 0))
    (else ((get (operator exp) 'deriv)
            (operands exp) var)))
  )
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))




;a. Explain what was done above. Why can’t we assimilate the predicates number? and variable? into the
;data-directed dispatch?

; operator is '+ or '*.

; I think we could assimilate them ? But it wouldn't be pretty because `operator` and `operands` wouldn't work out of the box.
; we would need to hardcode the number and variable special cases inside these procedures (also there isn't really an 'operator' for these).
; And also register a 'deriv something for them.
; Overall it's a lot simpler to keep them outside of the dispatch.



;b. Write the procedures for derivatives of sums and products, and the auxiliary code required to install them in
;the table used by the program above.

;(define (put op type item))
;(define (get op type))


(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? exp num) (and (number? exp) (= exp num)))



; personal implementation of get and put (required to test the code !!)
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


(define (install-deriv-package)
  (define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
      ((=number? a2 0) a1)
      ((and (number? a1) (number? a2))
        (+ a1 a2))
      (else (list '+ a1 a2)))
    )

  (define (addend operands) (car operands))
  (define (augend operands) (cadr operands))

  (define (make-product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
      ((=number? m1 1) m2)
      ((=number? m2 1) m1)
      ((and (number? m1) (number? m2)) (* m1 m2))
      (else (list '* m1 m2))))

  (define (multiplier operands) (car operands))
  (define (multiplicand operands) (cadr operands))



  ; note how these reference the global 'deriv' procedure
  (define (deriv-sum operands var)
    (make-sum
      (deriv (addend operands) var)
      (deriv (augend operands) var))
    )

  (define (deriv-product operands var)
    (make-sum
      (make-product
        (deriv (multiplier operands) var)
        (multiplicand operands)
        )
      (make-product
        (multiplier operands)
        (deriv (multiplicand operands) var)
        )
      )
    )
  (put '+ 'deriv deriv-sum)
  (put '* 'deriv deriv-product)


  ; c. adding exponentiation rule.
  ; note I'm putting everything in a single package. We need make-sum, make-product here.
  ; maybe it would make sense to move this outside, it would enable separate packages for each operator.
  ; each package would just contain the derivation function (and the `put` call to register it).
  (define (make-exponentiation base exponent)
    (cond ((=number? exponent 1) base)
      ((=number? exponent 0) 1)
      (else (list '** base exponent))
      )
    )
  (define (base operands)
    (car operands)
    )
  (define (exponent operands)
    (cadr operands)
    )

  (define (deriv-exponentiation operands var)
    (make-product
      (make-product
        (exponent operands)
        (make-exponentiation (base operands) (- (exponent operands) 1))
        )
      (deriv (base operands) var)
      )
    )

  (put '** 'deriv deriv-exponentiation)
  )

(install-deriv-package)
op-table
(get '+ 'deriv )
(equal? (caar op-table) '**)
; expected: true


(get '* 'deriv )
; xy(x + 3)
(deriv '(* (* x y) (+ x 3)) 'x)
;Value: (+ (* x y) (* y (+ x 3)))

(deriv '(** x 2) 'x)



