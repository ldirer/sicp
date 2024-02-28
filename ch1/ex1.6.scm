(define (sqrt-iter guess x)
  (if (good-enough? guess x)
    guess
    (sqrt-iter (improve guess x)
               x)))

(define (improve guess x) (average guess (/ x guess)))
(define (average x y) (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))



(define (sqrt x) (sqrt-iter 1.0 x))

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

(new-if (= 2 3) 0 5)
; 5
(new-if (= 1 1) 0 5)
; 0


(define (sqrt-iter-new guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter-new (improve guess x)
                     x)))



; because evaluation is using applicative order, the arguments of new-if are going to be evaluated. 
; This means both branches of the condition will always be evaluated, whereas with the special form only one is.
; At the end of the day this will never return, it will always be looping inside `sqrt-iter-new` even when `good-enough

; Tested behavior:
(sqrt-iter-new 1.0 2)
;Aborting!: maximum recursion depth exceeded

; Oh! Interesting. I didn't get that earlier with (define (p) (p)) ! 
; --> This is because of tail recursion optimization ! 
; It's clear now that I'm a few sections further in the book.
; a recursive function like this crashes in Python (instead of looping indefinitely).
