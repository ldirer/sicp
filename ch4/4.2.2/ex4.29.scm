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



; > Exhibit a program that you would expect to run much more slowly without memoization than with memoization.

; NOT A RELEVANT PROGRAM
(define (fibo n)
  (if (< n 2)
    1
    (+ (fibo (- n 1)) (fibo (- n 2)))
    )
  )

;(fibo 20)
; this isn't relevant because we are never *reusing thunks*.
; I don't really have an original relevant example.
; not original
(define (add-three fn a)
  (define value (fn a))
  ; without memoization, this will re-evaluate the value thunk 3 times
  (+ value value value)
  )



