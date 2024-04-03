; load the new apply-generic.
; NOTE THIS DEFINES GLOBAL VARIABLES AND NEEDS TO BE CALLED BEFORE ANY CODE REGISTRATING THINGS (=installing packages)
; order matters
(load "ch2/2.5.2/generic.scm")

;
;(define (exp x y) (apply-generic 'exp x y))
;
;; should be in the scheme-number package
;; we can do it here because there's no need to tag the result if it's a number
;; and we have the simpler number representation
; from book
(put 'exp '(scheme-number scheme-number) (lambda (x y) (expt x y)))

(define (exp x y) (apply-generic 'exp x y))
;
;
(exp 3 4)
; expected: 81

(define z (make-complex-from-real-imag 3 4))

; a.
;(exp z z)
; expected (Because the complex package didn't register `'exp`)
; "No method for these types (exp (complex complex))"


; With Louis Reasoner coercion procedures
(define (scheme-number->scheme-number n) n)
(define (complex->complex n) n)
(put-coercion 'scheme-number 'scheme-number scheme-number->scheme-number)
(put-coercion 'complex 'complex complex->complex)

;(exp z z)
; infinite loop !

; b.
; `apply-generic` works correctly as it is !

;c. done in `apply.scm`.


