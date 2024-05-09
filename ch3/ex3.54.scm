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

(define (mul-streams s1 s2)
  (stream-map * s1 s2)
  )

; n-th element (counting from 0) should be (n+1)!
(define factorials
  (cons-stream 1 (mul-streams factorials (stream-cdr integers))))

(display-stream (until factorials 10))

