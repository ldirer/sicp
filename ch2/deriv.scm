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

(define (=number? exp num) (and (number? exp) (= exp num)))
(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))
