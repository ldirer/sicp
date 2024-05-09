(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")
;3.50: n-ary stream-map
(load "ch3/ex3.50.scm")

(define (sign-change-detector curr prev)
  (cond
    ((and (< curr 0) (> prev 0)) -1)
    ((and (> curr 0) (< prev 0)) +1)
    (else 0)
    )
  )

(define (make-zero-crossings input-stream last-value)
  ; added termination handling (not in the book) to test procedure on finite sequences
  (if (stream-null? input-stream)
    the-empty-stream
    (cons-stream
      (sign-change-detector (stream-car input-stream) last-value)
      (make-zero-crossings (stream-cdr input-stream)
        (stream-car input-stream)))
    )
  )

(define (stream-from-list lst)
  (if (null? lst)
    the-empty-stream
    (cons-stream (car lst) (stream-from-list (cdr lst)))
    )
  )

(define sense-data (stream-from-list (list 1 2 1.5 1 0.5 -0.1 -2 -3 -2 -0.5 0.2 3 4)))
(display-stream (until sense-data 20))

(define zero-crossings (make-zero-crossings sense-data 0))

(display-stream (until zero-crossings 20))


; approximately equivalent version based on Eva Lu Ator's remark
(define zero-crossings
  (stream-map sign-change-detector sense-data (cons-stream 0 sense-data)))
(display-stream (until zero-crossings 20))
