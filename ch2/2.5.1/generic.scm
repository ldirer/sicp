(load "ch2/2.5.1/apply.scm")

;generic arithmetic
(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))


(load "ch2/2.5.1/complex.scm")
(load "ch2/2.5.1/rational.scm")
(load "ch2/2.5.1/scheme-number.scm")
(install-complex-package)
(install-rational-package)
(install-scheme-number-package)