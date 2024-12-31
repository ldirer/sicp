(load "testing.scm")
(load "ch4/4.4.logic/ex4.76_and_optimized.scm")


(define one-two (cons-stream 1 (cons-stream 2 the-empty-stream)))

(define (stream-from-list lst)
  (if (null? lst)
    the-empty-stream
    (cons-stream (car lst) (stream-from-list (cdr lst)))
    )
  )

(define (list-from-stream s)
  (if (stream-null? s) '() (cons (stream-car s) (list-from-stream (stream-cdr s))))
  )

(define expected (stream-from-list '((1 1) (2 1) (1 2) (2 2))))
(define actual (stream-product (list one-two one-two)))
(check-equal "stream product" (list-from-stream actual) (list-from-stream expected))

