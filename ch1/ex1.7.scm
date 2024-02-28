; Explain book statements:
; 1. "The good-enough? test will not be very effective for small numbers[...]" because an error of 0.001 for a result 
; that is << 0.001 is huge relative to the result.
; 2. "Also, in real computers, arithmetic operations are almost always performed with limited precision. 
; This makes our test inadequate for very large numbers."
; -> Uh. not sure here.
; I imagine we might have a **correct** square root produce a number (when squared) that is more than 0.001 away from the target. 
; Even if it's the correct answer ! Because limited precision.
;



(sqrt 0.01)
;Value: .10032578510960605  ; correct

(sqrt 0.003)
;Value: .05815193427238369

; In [3]: math.sqrt(0.003)
; Out[3]: 0.05477225575051661


(sqrt 1e50)
; hangs - presumably never terminates due to precision issues.


; maybe improved guessing strategy:

(define (good-enough? previous_guess guess)
  (< (abs (/ (- previous_guess guess) guess)) 0.001))

(define (sqrt-iter previous_guess guess x)
  (if (good-enough? previous_guess guess)
    guess
    (sqrt-iter guess (improve guess x)
               x)))

(define (improve guess x) (average guess (/ x guess)))
(define (average x y) (/ (+ x y) 2))




(define (sqrt x) (sqrt-iter -1.0 1.0 x))


(sqrt 0.003)
;Value: 5.4772255750587126e-2
(sqrt 1e50)
;Value: 1.0000003807575104e25


