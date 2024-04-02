;load the simpler number representation
;(load "ch2/2.5.1/ex2.78.scm")

; load the new apply-generic.
; NOTE THIS DEFINES GLOBAL VARIABLES AND NEEDS TO BE CALLED BEFORE ANY CODE REGISTRATING THINGS (=installing packages)
; order matters
(load "ch2/2.5.2/apply.scm")
(load "ch2/2.5.1/generic.scm")

;
;(define (exp x y) (apply-generic 'exp x y))
;
;; should be in the scheme-number package
;; we can do it here because there's no need to tag the result if it's a number
;; and we have the simpler number representation
; from book
(put 'exp '(scheme-number scheme-number) (lambda (x y) (expt x y)))

(define (exp x y) (apply-generic 'exp x y))

(number? 3)
;expected: true
;
;
;

(exp 3 4)
(define z (make-complex-from-real-imag 3 4))
(exp z z)
; Because the complex package didn't register `'exp`, this does not
