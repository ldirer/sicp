;Which of the ﬁve possibilities in the parallel execution shown above remain if we instead serialize
;execution as follows:
(define x 10)
(define s (make-serializer))
(parallel-execute
  (lambda () (set! x ((s (lambda () (* x x)))))) ; P1
  (s (lambda () (set! x (+ x 1)))) ; P2
  )


; reminder possible values before serialization:
;101: P1 sets x to 100 and then P2 increments x to 101.
;121: P2 increments x to 11 and then P1 sets x to x * x.
;110: P2 changes x from 10 to 11 between the two times that
;     P1 accesses the value of x during the evaluation of (* x x).
;11: P2 accesses x, then P1 sets x to 100, then P2 sets x.
;100: P1 accesses x (twice), then P2 sets x to 11, then P1 sets x.


; Possible values that remain are 101 and 121.
; --> INCORRECT, I was assuming we were serializing the entire procedures. But the serialization in P1 is only on the computation, not on the `set`.
; So I think 101, 121 AND 100 remain.
