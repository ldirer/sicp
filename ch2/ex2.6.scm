#lang sicp

(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n) 
   (lambda (f) (lambda (x) ((f (n f)) x)))
   )


; this is MUCH simpler to understand imo by looking at Church numerals as mapping integers to the application of a function f N times.
; f o f o f o f
; the Church numeral function can be seen as having two parameters f and x. Or curry-fied like here.



(define one (lambda (f) (lambda (x) (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))


one

(define (inc k) (+ k 1))
(add-1 zero)


((one inc) 0)
; 1
((two inc) 0)
; 2

;; this works but there might be a shorter version
;(define (add a b)
;  (lambda (f) (lambda (x) ((a f) ((b f) x)))
;))


; here's a not-much-shorter version
(define (compose f g) (define (result x) (f (g x))) result)

(define (add a b)
  (lambda (f) (compose (a f) (b f))
))


(define three (add one two))
(define six (add three three))


((three inc) 0)
((six inc) 0)




(define (power a b)
  (b a)
)

(((power six three) inc) 0)
; 6**3 = 216
