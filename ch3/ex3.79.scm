(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")
; n-ary stream-map
(load "ch3/ex3.50.scm")
; load previous to compare with paper solution in special case of f(x,y)=ax+by
(load "ch3/ex3.78.scm")


(define (integral integrand initial-value dt)
  (cons-stream initial-value
    (if (stream-null? (force integrand))
      the-empty-stream
      (integral
        (delay (stream-cdr (force integrand)))
        (+ (* dt (stream-car (force integrand)))
          initial-value)
        dt)))
  )

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y
  )

; dy/dt = y, y(0)=1
; dt 0.001 so 1000th element is time t=1, we expect `e`.
(stream-ref (solve (lambda (y) y) 1 .001) 1000)



; d2y/dt2 - a * dy/dt - b*y = 0
(define (solve-2nd f dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay d2y) dy0 dt))
  (define d2y (stream-map f y dy))
  y
  )

(define (linear a b)
  (define (f x y)
    (+ (* a x) (* b y))
    )
  f
  )


(define f (linear 1 1))

(stream-ref (solve-2nd f 0.0001 1 1) 10000)
(paper-solution 1 1 1)
