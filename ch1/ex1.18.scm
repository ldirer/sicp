(define (halve n) (/ n 2))
(define (double x) (+ x x))

(define (mult a b)

  (define (mult-iter a b result steps)
    (cond ((= a 0)
            (begin (newline) (display "steps: ") (display steps) result))
      ((even? a) (mult-iter (halve a) (double b) result (+ steps 1)))
      (else (mult-iter (- a 1) b (+ result b) (+ steps 1)))
      )
    )
  (mult-iter a b 0 0)
  )

(mult 100 12)
; expected: 1200
(mult 10000 12)
; expected: 120000

(mult 256 1)
; steps: 9
(mult 512 1)
; steps: 10

(mult 3 4)
; expected: 12
