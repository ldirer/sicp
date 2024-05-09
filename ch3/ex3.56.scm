(load "ch3/3.5/streams.scm")
(load "ch3/ex3.50.scm")

(define (until s n)
  (cond
    ((or (stream-null? s) (= n 0)) the-empty-stream)
    (else (cons-stream (stream-car s) (until (stream-cdr s) (- n 1))))
    )
  )



(define (merge s1 s2)
  (cond ((stream-null? s1) s2)
    ((stream-null? s2) s1)
    (else
      (let ((s1car (stream-car s1))
             (s2car (stream-car s2)))
        (cond ((< s1car s2car)
                (cons-stream
                  s1car
                  (merge (stream-cdr s1) s2)))
          ((> s1car s2car)
            (cons-stream
              s2car
              (merge s1 (stream-cdr s2))))
          (else
            (cons-stream
              s1car
              (merge (stream-cdr s1)
                (stream-cdr s2))))))))
  )


(define S (cons-stream
            1
            (merge
              (scale-stream S 2)
              (merge
                (scale-stream S 3)
                (scale-stream S 5)
                )
              )
            )
  )

(display-stream (until S 20))