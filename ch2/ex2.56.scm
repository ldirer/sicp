(define (deriv exp var)
  (cond ((number? exp) 0)
    ((variable? exp) (if (same-variable? exp var) 1 0))
    ((sum? exp) (make-sum (deriv (addend exp) var)
                  (deriv (augend exp) var)))
    ((product? exp)
      (make-sum
        (make-product (multiplier exp)
          (deriv (multiplicand exp) var))
        (make-product (deriv (multiplier exp) var)
          (multiplicand exp))))
    (else
      (error "unknown expression type: DERIV" exp))))


;simpler versions - works but produce unsimplified expressions
;(define (make-sum a1 a2) (list '+ a1 a2))
;(define (make-product m1 m2) (list '* m1 m2))

(define (=number? exp num) (and (number? exp) (= exp num)))
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
    ((=number? a2 0) a1)
    ((and (number? a1) (number? a2))
      (+ a1 a2))
    (else (list '+ a1 a2)))
  )

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
    ((=number? m1 1) m2)
    ((=number? m2 1) m1)
    ((and (number? m1) (number? m2)) (* m1 m2))
    (else (list '* m1 m2))))

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))


; addend: first term in addition.
; augend: second term in addition.
(define (sum? x) (and (pair? x) (eq? (car x) '+)))
(define (addend s) (cadr s))
(define (augend s) (caddr s))

(define (product? x) (and (pair? x) (eq? (car x) '*)))
(define (multiplier p) (cadr p))
(define (multiplicand p) (caddr p))


; xy(x + 3)
(deriv '(* (* x y) (+ x 3)) 'x)
;Value: (+ (* x y) (* y (+ x 3)))
; note this is equal to 2yx + 3y so all is well.




; handling d(u**n)/dx
(define (deriv exp var)
  (cond ((number? exp) 0)
    ((variable? exp) (if (same-variable? exp var) 1 0))
    ((sum? exp) (make-sum (deriv (addend exp) var)
                  (deriv (augend exp) var)))
    ((product? exp)
      (make-sum
        (make-product (multiplier exp)
          (deriv (multiplicand exp) var))
        (make-product (deriv (multiplier exp) var)
          (multiplicand exp))))
    ((exponentiation? exp)
      (make-product
        (make-product
          (exponent exp)
          (make-exponentiation (base exp) (- (exponent exp) 1))
          )
        (deriv (base exp) var)
        )
      )
    (else
      (error "unknown expression type: DERIV" exp))))

(define (make-exponentiation base exponent)
  (cond ((=number? exponent 1) base)
    ((=number? exponent 0) 1)
    (else (list '** base exponent))
    )
  )
(define (base exp)
  (cadr exp)
  )
(define (exponent exp)
  (caddr exp)
  )
(define (exponentiation? exp)
  (and (pair? exp) (eq? (car exp) '**))
  )

(deriv '(** x 2) 'x)
; expected: (* 2 x)
