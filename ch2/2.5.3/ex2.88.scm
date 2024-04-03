; define subtraction, see polynomial package

(load "ch2/2.5.3/generic.scm")

(define p (make-polynomial 'x (list (list 0 1) (list 1 1))));
p

(add p p)


(negate (make-rational 2 3))
; expected: rational -2 3

(define q (sub p p))

(=zero? p)
; expected: false
(=zero? q)
; expected: true
