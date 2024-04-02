(load "ch2/2.5.1/generic.scm")


(define (equ? x y)
  (apply-generic 'equ? x y)
  )


; we add a new method in each package and register it :
;(define (number-equ? x y)
;  (= x y)
;  )
;(put 'equ? '(scheme-number scheme-number) number-equ?)
;
;(define (rational-equ? x y)
;  (and (= (numer x) (numer y)) (= (denom x) (denom y)))
;  )
;(put 'equ? '(rational rational) rational-equ?)
;
;(define (complex-equ? x y)
;  (and (= (real-part x) (real-part y)) (= (imag-part x) (imag-part y)))
;  )
;(put 'equ? '(complex complex) complex-equ?)



;fixes the issue described in ex2.77
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))

(define z1 (make-complex-from-real-imag 3 0))
(define z2 (make-complex-from-mag-ang (magnitude z1) (angle z1)))
(equ? z1 z2)
;expected: true - but we're cheating. Most of the time this doesn't work due to rounding errors.

