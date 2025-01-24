;use eceval
(define (fib n)
  (if (< n 2)
    n
    (+ (fib (- n 1)) (fib (- n 2)))
    )
  )


(fib 3)
; 2
;(total-pushes = 128 maximum-depth = 18)

(fib 4)
; 3
;(total-pushes = 240 maximum-depth = 23)

(fib 5)
; 5
;(total-pushes = 408 maximum-depth = 28)

(fib 6)
; 8
;(total-pushes = 688 maximum-depth = 33)

(fib 7)
; 13
;(total-pushes = 1136 maximum-depth = 38)

;max-depth formula:  5*n + 3
; total number of pushes:
; S(n) = S(n - 1) + S(n - 2) + 40
; The constant k from the text is 40.

; Assuming the formula is correct, let's work out the coefficients:
; a = 56
; (5*a+b) - (3*a+b) = 240 - 128 = 112
; b = 128 - 3*56 = -40
; S(n) = fib(n+1) * 56 - 40
;

; Now proving the formula:

; I want to get back to a form where `a * U(n+2) + b * U(n+1) + c * U(n) = 0`
; because I know this can be solved for (note the absence of constant term).

; Consider a new sequence U(n) = S(n) - c
; U(n) = S(n-1) + S(n-2) + 40 - c
; U(n) = S(n-1) - c + S(n -2) + 40

; Let's try c=-40
; U(n) = S(n) + 40
; U(n) = S(n) + 40 = S(n-1) + S(n-2) + 40 + 40 = U(n-1) + U(n-2)
; So U(n) is a fibonacci suite.
; U(3) = 128 + 40 = 168; U(4) = 240 + 40 = 280
; 56 * 3 = 168
; 56 * 5 = 280
; U(n) = 56 * fib(n+1)

; Taking a step back (just one :)) the 56 factor feels like it's large!
