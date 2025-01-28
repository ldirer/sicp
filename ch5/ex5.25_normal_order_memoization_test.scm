; use eceval normal

;ex 4.30 to check memoization
(define count 0)
(define (id x)
  (set! count (+ count 1))
  x
  )

(define (square x) (* x x))

(square (id 10))
; <response 1>

count
; <response 2>

; A. When the evaluator memoizes:
; response 1: 100
; response 2: 1
; B. When the evaluator does not memoize:
; response 1: 100
; response 2: 2
