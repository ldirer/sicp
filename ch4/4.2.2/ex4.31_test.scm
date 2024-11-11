(load "ch4/4.2.2/ex4.31.scm")
(load "ch4/4.1.4/primitives.scm")

(define test-env (setup-environment))

;(eval '(begin (define (square-regular x) (* x x)) (square-regular 3)) test-env)
;(eval '(begin (define (square-regular x) (* x x)) (square-regular (begin 3))) test-env)

; to check lazy behavior we reuse the logic of previous exercises, measuring side effects by mutating counter variables.
(eval '(begin
         (define y 3)
         (define regular-count 0)
         (define lazy-count 0)
         (define lazy-memo-count 0)
         (define (square-lazy-memo (x lazy-memo))
           (set! lazy-memo-count 0)
           (* x x)
           )
         (define (square-lazy (x lazy))
           (set! lazy-count 0)
           (* x x))
         (define (square-regular x)
           (set! regular-count 0)
           (* x x))
         (square-lazy (begin (set! lazy-count (+ lazy-count 1)) y))
         (square-lazy-memo (begin (set! lazy-memo-count (+ lazy-memo-count 1)) y))
         (square-regular (begin (set! regular-count (+ regular-count 1)) y))
         (newline)
         (display "lazy-count=")
         (display lazy-count)
         (newline)
         (display "lazy-memo-count=")
         (display lazy-memo-count)
         (newline)
         (display "regular-count=")
         (display regular-count)
         (newline)
         ) test-env)

; expected (regular count should go up to 2 but then be reset in the square function body):
; lazy-count=2
; lazy-memo-count=1
; regular-count=0
