; use eceval

(define (f)
  (cond
    ((= 0 0) (display "one "))
    ((< 1 0) (display "two "))
    ((< 1 2) (display "three "))
    (else (display "four "))
    )
  )

(f)
; expected: one


(define (g)
  (let ((x 1)
         (y 2))
    (+ x y)
    ))

(g)
; expected: 3