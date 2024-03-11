(load "ch2/2.5/generic.scm")

(define (=zero? x) (apply-generic '=zero? x))

;load the simpler number representation
(load "ch2/2.5/ex2.78.scm")

(=zero? 0)
;expected: true
(=zero? (make-rational 0 100))
;expected: true

(=zero? (make-rational 1 100))
;expected: false

(=zero? (make-complex-from-mag-ang 0 1))
;expected: true
