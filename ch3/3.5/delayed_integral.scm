; section 3.5.4
(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")

(define (integral integrand initial-value dt)
  (define int (cons-stream initial-value (add-streams (scale-stream integrand dt) int)))
  int
  )

; dy/dt = f(y)
; We want to write y(t) = integral over time of f(y).
; In code:

(define (solve f y0 dt)
  (define y (integral dy y0 dt))
  (define dy (stream-map f y))
  y
  )

; this doesn't work because dy is used on line 1 and isn't defined until the second line of the function.
; ("unbound variable dy")
; IF IT WAS LAZILY EVALUATED THO.
(define (integral delayed-integrand initial-value dt)
  (define int (cons-stream initial-value (add-streams (scale-stream (force delayed-integrand) dt) int)))
  int
)

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y
  )


; dy/dt = y, y(0)=1
; dt 0.001 so 1000th element is time t=1, we expect `e`.
(stream-ref (solve (lambda (y) y) 1 0.001) 1000)



