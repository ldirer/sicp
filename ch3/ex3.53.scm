;Without running the program, describe the
;elements of the stream deﬁned by
;(define s (cons-stream 1 (add-streams s s)))

; ran the program to check my answer.


(load "ch3/3.5/streams.scm")

; n-args stream-map from ex3.50
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
    the-empty-stream
    (cons-stream
      (apply proc (map stream-car argstreams))
      (apply stream-map proc (map stream-cdr argstreams))))
  )


(define (until s n)
  (cond
    ((or (stream-null? s) (= n 0)) the-empty-stream)
    (else (cons-stream (stream-car s) (until (stream-cdr s) (- n 1))))
    )
  )


(define (add-streams s1 s2) (stream-map + s1 s2))
; tests to fix my stream-map code
;(define ones (cons-stream 1 ones))
;(define twos (stream-map (lambda (x) (+ x 1)) ones))
;(define integers
;  (cons-stream 1 (add-streams ones integers)))
;(display-stream (until integers 10))

(define s (cons-stream 1 (add-streams s s)))
;expected: 1 2 4 8 16...

(display-stream (until s 10))
