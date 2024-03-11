(define (halve n) (/ n 2))
(define (double x) (+ x x))

(define (mult-rec a b)
  (cond ((= a 1) b)
    ((even? a) (mult-rec (halve a) (double b)))
    (else (+ (mult-rec (- a 1) b) b))
    )
  )

(mult-rec 100 12)
; expected: 1200
(mult-rec 3 4)
; expected: 12


