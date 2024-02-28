(define (square x) (* x x))


(define (even? n) (= (remainder n 2) 0))

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))


; Alyssa P. Hacker proposal:
(define (expmod base exp m)
  (remainder (fast-expt base exp) m)
  )

; She's right that the given procedure correctly returns the value of base ** exp modulo m
; However numbers will get HUGE really fast here...
; I imagine things will take more time to run ? Not run at all ?


; this runs fine
(expmod 999 1013 1013)
;Value: 999

; this does not run fine (runs indefinitely) !
(define large-prime 1000000000063)
(expmod 999 large-prime large-prime)





