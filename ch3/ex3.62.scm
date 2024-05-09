(load "ch3/ex3.61.scm")

;  s1 / s2 = X
; s1 * (1 / s2) = X
; we need the denominator to start with a non-zero constant term so we can invert it.
(define (div-series s1 s2)
  (mul-series s1 (invert-series s2))
  )

(define tan-series (div-series sine-series cosine-series))

(eval-series tan-series (/ 3.14 4) 100)
; should be around 1


(eval-series tan-series (/ 3.14 6) 100)
; expected: (1/2) / (sqrt(3)/2) = 1/sqrt(3) = 0.5773..
