(load "ch1/ex1.37.scm")

(define (n i) 1.)
(define (d i)
  (
    cond ((= (remainder i 3) 2) (/ (* (+ i 1.) 2) 3))
           (else 1.)
    )
  )
(define (euler-e k)
  (+ 2 (cont-frac-i n d k))
  )

(d 8)
; expected: 6
(d 11)
; expected: 8

(euler-e 100)
; 2.71...

