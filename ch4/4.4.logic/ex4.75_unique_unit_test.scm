(load "testing.scm")
(load "ch4/4.4.logic/ex4.75_unique.scm")

(define test-stream (cons-stream 1 the-empty-stream))

(check-equal "is singleton" (is-singleton? test-stream) true)
(check-equal "not singleton" (is-singleton? (cons-stream 1 test-stream)) false)
