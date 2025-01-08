; use myamb

; Beware of top-level `define` for variables. They don't behave as expected.
; Top of my head (sigh), I *think* the explanation is: top-level define are never re-run.
(define (number) (amb 1 2 3))

;(define number-variable (amb 1 2 3))
;number-variable
;value: 1
;try-again
;;;; There are no more values of 'number-variable'

(define (f)
  (define num (number))
  (require-fail (require (equal? num 2)))
  num
  )

(f)
; expected: 1
try-again
; expected: 3

