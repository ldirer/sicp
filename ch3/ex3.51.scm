(load "ch3/3.5/streams.scm")

(define (show x)
  (display-line x)
  x
  )

(define x
  (stream-map
    show
    (stream-enumerate-interval 0 10)
    )
  )

(stream-ref x 5)
; prints 1 2 3 4 5, returns 5
(stream-ref x 7)
; expected: prints 6 7, returns 7

