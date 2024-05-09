; testing parallel execute and friends because it took me quite some time to make things work.
;(load "ch3/3.4.2/serializer.scm")
; parallel includes a version of mutex and make-serializer
(load "ch3/3.4.2/parallel.scm")
(load "ch3/3.4.2/sleep.scm")



(define x 10)
(define test1 (lambda () (set! x (* x x))))
(define test2 (lambda () (set! x (+ x 1))))

(define terminator2 (parallel-execute test1 test2))
(sleep 1)
(display "x=")
(display x)
(newline)
(terminator2)

(define x 10)
(parallel-execute
  (lambda () (set! x (* x x))) ; P1
  (lambda () (set! x (+ x 1)))) ; P2
(sleep 1)
x