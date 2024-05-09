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
(stream-ref (solve (lambda (y) y) 1 .001) 1000)



; d2y/dt2 - a * dy/dt - b*y = 0

(define (solve-2nd a b dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay d2y) dy0 dt))
  (define d2y (add-streams (scale-stream y b) (scale-stream dy a)))
  y
  )



; based on a, b (assuming a2+4ab is > 0).
(define (lambda1 a b) (/ (+ 1 (sqrt (+ (square a) (* 4 b)))) 2))
(define (lambda2 a b) (/ (- 1 (sqrt (+ (square a) (* 4 b)))) 2))

; I mean I should have just used a=0 to check my work. Oh well.
(define (paper-solution a b t)
  (if (<= (+ (square a) (* 4 a b)) 0)
    error "wrong assumptions! math won't agree"
    )
  ; then our solutions are alpha * exp(lambda1 * t) + beta * exp(lambda2 * t)
  ; Assuming y(0)=1 and y'(0)=1, we get (I figured the calculations out on paper):
  (define lambd1 (lambda1 a b))
  (define lambd2 (lambda2 a b))
  (define alpha (/ (- 1 lambd2) (- lambd1 lambd2)))
  (define beta (/ (- 1 lambd1) (- lambd2 lambd1)))

  (+ (* alpha (exp (* lambd1 t))) (* beta (exp (* lambd2 t))))
  )

(stream-ref (solve-2nd 1 1 .0001 1 1) 10000)
(paper-solution 1 1 1)
; making dt smaller and smaller increases precision