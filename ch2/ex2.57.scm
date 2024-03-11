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
;(define (make-sum a1 a2)
;  (cond
;    ((null? a2) a1)
;    ; trouble is A LOT OF THINGS are pairs. Like a product. Or another sum. Damn.
;    ; can't differentiate between these... Need the n-ary arguments I think. :(
;    ((pair? a2) (make-sum (make-sum a1 (car a2)) (cdr a2)))
;    ((=number? a1 0) a2)
;    ((=number? a2 0) a1)
;    ((and (number? a1) (number? a2))
;      (+ a1 a2))
;    (else (list '+ a1 a2)))
;  )

(define (make-sum-single a1 a2)
  (cond ((=number? a1 0) a2)
    ((=number? a2 0) a1)
    ((and (number? a1) (number? a2))
      (+ a1 a2))
    (else (list '+ a1 a2)))
  )

;(define depth 0)
(define (make-sum a1 . a2s)
;  (if (< depth 4) (begin
;                    (newline)
;                    (display a1 "." a2s)
;                    (display ".")
;                    (display a2s)
;                    (set! depth (+ depth 1))
;                    )
;    )
  (cond
    ((null? a2s) a1)
    (else (apply make-sum (make-sum-single a1 (car a2s)) (cdr a2s)))
    )
  )

; addend: first term in addition.
; augend: second term (or rest of the terms !) in addition.
(define (sum? x) (and (pair? x) (eq? (car x) '+)))
(define (addend s) (cadr s))
(define (augend s) (apply make-sum (caddr s) (cdddr s)))
; before:
;(define (augend s) (caddr s))


(define (make-product-single m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
    ((=number? m1 1) m2)
    ((=number? m2 1) m1)
    ((and (number? m1) (number? m2)) (* m1 m2))
    (else (list '* m1 m2))))

(define (make-product m1 . m2s)
  (cond
    ((null? m2s) m1)
    (else (apply make-product (make-product-single m1 (car m2s)) (cdr m2s)))
    )
  )

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))



(define (product? x) (and (pair? x) (eq? (car x) '*)))
(define (multiplier p) (cadr p))
(define (multiplicand p) (apply make-product (caddr p) (cdddr p)))


; xy(x + 3)
(deriv '(* (* x y) (+ x 3)) 'x)

; n-ary addition test
(deriv '(+ 1 x x) 'x)

; with support for n-ary multiplication
(deriv '(* x y (+ x 3)) 'x)

;(pp #@12)

