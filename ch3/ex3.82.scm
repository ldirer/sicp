(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")
(load "ch3/ex3.79.scm")
; n-ary stream-map
(load "ch3/ex3.50.scm")



; still using the random builtin because I don't really have a random number generator (and we'd need one that respects a max value here)
(define (random-numbers-in-range low high)
  (cons-stream (+ low (random (- high low))) (random-numbers-in-range low high))
  )

; test
(display-stream-inline (until (random-numbers-in-range 0. 10.) 3))


;from book
(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
      (/ passed (+ passed failed))
      (monte-carlo
        (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
    (next (+ passed 1) failed)
    (next passed (+ failed 1))))


(define (estimate-integral P x1 x2 y1 y2)

  (define experiment-stream
    (stream-map P (random-numbers-in-range x1 x2) (random-numbers-in-range y1 y2))
    )
  (scale-stream (monte-carlo experiment-stream 0. 0.) (* (- x2 x1) (- y2 y1)))
  )


(define (P-in-unit-disk x y)
  (<= (+ (square x) (square y)) 1)
  )

(stream-ref (estimate-integral P-in-unit-disk -2. 2. -2. 2.) 100000)

