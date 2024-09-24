(load "testing.scm")
; a. checking this computes factorial
((lambda (n)
   ((lambda (fact) (fact fact n))
     (lambda (ft k)
       (if (= k 1)
         1
         (* k (ft ft (- k 1)))))))
  5)
; expected: 120

; writing fibonnaci in the same way
; technically the goal is to not use define, I'm using a top-level one for convenience.
(define (fibo n)
  ((lambda (n)
     ((lambda (fibo) (fibo fibo n))
       (lambda (self n)
         (if (< n 2)
           1
           (+ (self self (- n 1)) (self self (- n 2)))
           )
         )
       )
     ) n))

(map fibo '(1 2 3 4 5 6 7 8 9 10))


; b.

(define (f x)
  (define (even? n)
    (if (= n 0)
      true
      (odd? (- n 1))))
  (define (odd? n)
    (if (= n 0)
      false
      (even? (- n 1))))
  (even? x)
  )

(check-equal "old-style function returns false for odd number" (f 5) false)
(check-equal "old-style function returns true for even number" (f 6) true)

(define (f x)
  (
    (lambda (even? odd?) (even? even? odd? x))
    ; definition of even?
    (lambda (even? odd? n)
      (if (= n 0)
        true
        (odd? even? odd? (- n 1))
        )
      )
    ; definition of odd?
    (lambda (even? odd? n)
      (if (= n 0)
        false
        (even? even? odd? (- n 1))
        ))
      )
  )

(check-equal "new-style function returns false for odd number" (f 5) false)
(check-equal "new-style function returns true for even number" (f 6) true)
