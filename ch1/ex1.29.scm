(define (sum term a next b) 
  (if (> a b) 
    0
    (+ (term a)
     (sum term (next a) next b)
    )))


(define (simpson f a b n) 
  (define h (/ (- b a) n))
  (define (term_even a) (* (f a) 2))
  (define (term_odd a) (* (f a) 4))
  (define (next a) (+ a (* 2 h)))
  (* (/ h 3)
     (+
     (sum term_even a next b)
     (sum term_odd (+ a h) next b)
     )
   )
)

(define (cube x) (* x x x))


(simpson cube 0. 1. 100)
;Value: .24666666666666706
(simpson cube 0. 1. 1000)
;Value: .24966666666666748
(simpson cube 0. 1. 10000)
;Value: .25003333333328426


; results don't seem better than the `integral` procedure from the book.
; a bit surprising since they present Simpson's Rule as a more accurate method.
; n=1000 should be comparable to dx=0.001 (1000 steps in computation too).
; it's good but slightly worse ? Reported in the book:
; (integral cube 0 1 0.001)
; .249999875000001 


