(load "ch3/ex3.67.scm")
;Louis Reasoner's proposal
(define (pairs s t)
  (interleave
    (stream-map (lambda (x) list (stream-car s) x) t)
    (pairs (stream-cdr s) (stream-cdr t))
    )
  )


; it looks very reasonable, but it will cause an infinite loop. The call to `pairs` is evaluated straight away, when
; the key to this work is to delay the recursive call (using cons-stream).

;(display-stream (until (pairs integers integers) 10))
