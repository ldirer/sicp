; run:
; scheme --load "ch5/ex5.32_eceval.scm" < ch5/ex5.32_test.scm

(define (f a b) (+ a b))

(define (g) f)

; should run through the optimized version
(f 1 2)
; expected: 3

((g) 1 2)
; expected: 3



; Without optimization
; (f 1 2)
; (total-pushes = 16 maximum-depth = 5)
; With optimization:
; (f 1 2)
; (total-pushes = 12 maximum-depth = 5)
; Saved 2+2 pushes because we don't save `env` and `unev` when evaluating the operator in `(f 1 2)` and also in `(+ 1 2)`.
