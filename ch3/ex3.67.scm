(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")


(define (interleave s1 s2)
  (if (stream-null? s1)
    s2
    (cons-stream
      (stream-car s1)
      (interleave s2 (stream-cdr s1))
      )
    )
  )

(define (all-pairs s t)
  (cons-stream
    ; s0, t0
    (list (stream-car s) (stream-car t))
    (interleave
      (interleave
        ; (s0, t1), (s0, t2), ...
        (stream-map
          (lambda (x) (list (stream-car s) x))
          (stream-cdr t)
          )
        (stream-map
          (lambda (x) (list x (stream-car t)))
          (stream-cdr s)
          )
        )
      (all-pairs (stream-cdr s) (stream-cdr t))
      )
    )
  )


(display-stream (until (all-pairs integers integers) 40))
