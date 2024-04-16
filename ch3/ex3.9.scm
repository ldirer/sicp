(define (factorial n) (if (= n 1) 1 (* n (factorial (- n 1)))))

(define (factorial-iter n)
  (define (fact-iter product counter max-count)
    (if (> counter max-count)
      product
      (fact-iter (* counter product)
        (+ counter 1)
        max-count)))
  (fact-iter 1 1 n)
  )

;Show the environment structures created by evaluating (factorial 6) using each version of the factorial procedure.

(factorial 5)
(factorial-iter 5)


;(factorial 6) creates the following environments:
; E1: n=6, points to global env.
; E2: n=5, points to global env.
; E3: n=4, points to global env.
; E4: n=3, points to global env.
; E5: n=2, points to global env.
; E6: n=1, points to global env.

;(factorial-iter 6) creates the following environments:
; E1: n=6, factorial-iter definition, points to global env.
; E2: product=1, counter=1, max-count=6, points to E1.
; E3: product=1, counter=2, max-count=6, points to E1.
; E4: product=2, counter=3, max-count=6, points to E1.
; E5: product=6, counter=4, max-count=6, points to E1.
; E6: product=24, counter=5, max-count=6, points to E1.
; E7: product=120, counter=6, max-count=6, points to E1.
; E8: product=720, counter=7, max-count=6, points to E1.

; The book mentions this does not make it clear that the interpreter can execute such a procedure in a constant
; amount of space, and that tail recursion will be discussed later in section 5.4.

