(load "ch3/ex3.60.scm")
(load "ch3/3.5/series.scm")

;want to find X such that S*X=1
; (1+S_R) * X=1
; X+S_R * X = 1
; X = 1 - S_R * X
; assuming a power series with constant term 1
(define (invert-unit-series s)
  (cons-stream 1 (scale-stream (mul-series (stream-cdr s) (invert-unit-series s)) -1))
  )


(define (invert-series s)
  (if (= (stream-car s) 0)
    (error "cannot invert series without a constant term")
    (scale-stream (invert-unit-series (scale-stream s (/ 1 (stream-car s)))) (/ 1 (stream-car s)))
    )
  )
