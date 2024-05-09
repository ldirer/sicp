(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")


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
(stream-ref (solve (lambda (y) y) 1 0.001) 1000)

