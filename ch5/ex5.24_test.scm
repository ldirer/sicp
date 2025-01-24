; use eceval
; adjust code in eceval.scm to use the relevant cond controller.

(define (f-no-clauses)
  (cond)
  )

(define (f1)
  (cond
    ((= 0 0) 1)
    (else 2)
    )
  )
(define (f2)
  (cond
    ((= 0 2) (display "zero "))
    ((= 0 0) (display "one "))
    ((< 1 0) (display "two "))
    ((< 1 2) (display "three "))
    (else (display "four "))
    )
  )

(f-no-clauses)

(f1)
; expected: 1

(f2)
; expected: display "one "
