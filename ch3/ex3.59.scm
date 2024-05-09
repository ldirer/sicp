(load "ch3/3.5/streams.scm")
(load "ch3/ex3.50.scm")
(define (until s n)
  (cond
    ((or (stream-null? s) (= n 0)) the-empty-stream)
    (else (cons-stream (stream-car s) (until (stream-cdr s) (- n 1))))
    )
  )

(define (add-streams s1 s2) (stream-map + s1 s2))
(define ones (cons-stream 1 ones))
(define integers
  (cons-stream 1 (add-streams ones integers)))


(define (integrate-series s)
  (stream-map (lambda (x n) (/ x n)) s integers)
  )

(define exp-series
(cons-stream 1 (integrate-series exp-series)))

(display-stream (until exp-series 10))


(define cosine-series (cons-stream 1 (stream-map - (integrate-series sine-series))))
(define sine-series (cons-stream 0 (integrate-series cosine-series)))

(display-stream (until cosine-series 10))
(display-stream (until sine-series 10))

; DAMN. THIS IS IMPRESSIVE??