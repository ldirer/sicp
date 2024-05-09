(load "ch3/ex3.47_1.scm")
(define s (make-semaphore 2))
(define p1 (lambda () (s 'acquire) (display "process 1") (newline) (sleep 2) (s 'release) (print-done 1)))
(define p2 (lambda () (s 'acquire) (display "process 2") (newline) (sleep 2) (s 'release) (print-done 2)))
(define p3 (lambda () (s 'acquire) (display "process 3") (newline) (sleep 2) (s 'release) (print-done 3)))
(define p4 (lambda () (s 'acquire) (display "process 4") (newline) (sleep 2) (s 'release) (print-done 4)))

(parallel-execute p1 p2 p3 p4)
; as expected stdout shows 2 processes are executed, then when they complete the two following ones run.
; I'm attributing the weird delays to the fact that processes are 'busy waiting'.
(sleep 10)
