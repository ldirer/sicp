(load "ch3/3.5/streams.scm")
(load "ch3/ex3.50.scm")
(load "ch3/ex3.59.scm")

(define (mul-series s1 s2)
  (cons-stream
    (* (stream-car s1) (stream-car s2))
    (add-streams
      (scale-stream (stream-cdr s2) (stream-car s1) )
      (mul-series (stream-cdr s1) s2))
    )
  )


(define cos-squared (mul-series cosine-series cosine-series))
(define sin-squared (mul-series sine-series sine-series))
