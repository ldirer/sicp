
(define (product term a next b)
  (cond ((> a b) 1)
        (else (* (term a) (product term (next a) next b)))
  ))


(define (inc x) (+ x 1))



; procedure generating an iterative process

(define (producti term a next b)
  (define (product-helper term a next b prod)
    (cond ((> a b) prod)
            (else (product-helper term (next a) next b (* prod (term a))))
      ))
  (product-helper term a next b 1)
  )
  

(product (lambda (x) x) 1 inc 10)
; 3628800
(producti (lambda (x) x) 1 inc 10)
; 3628800


(define (factorial n) (product (lambda (x) x) 1 inc n))
(factorial 5)
; 120

(define (pi-4-approx n) 
 (define (term i) (* (/ (* 2 i) (+ (* 2 i) 1)) (/ (* 2 (+ i 1)) (+ (* 2 i) 1))))
 (producti term 1. inc n)
)




