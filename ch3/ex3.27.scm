; memo-fib has O(n) complexity because it stores previous results.
; each computation is done only once.

;Draw an environment diagram to analyze the computation
;of (memo-fib 3). Explain why memo-fib computes the n th
;Fibonacci number in a number of steps proportional to n.
;Would the scheme still work if we had simply deﬁned memo-
;fib to be (memoize fib)?


; when (memoize (lambda n...)) is called an environment is created.
; In that environment there's the table storing results.
; the function returned by memoize points to this environment, so every time memo-fib the table can be checked for cached results.

;Would the scheme still work if we had simply deﬁned memo-
;fib to be (memoize fib)?
; No because `memo-fib` would still call the uncached `fib` variant.
; I'd say it would work if we defined `fib` to be `memoize fib`.
; -> tested below, looks correct.


; also see alternate (similar) explanation: https://eli.thegreenplace.net/2007/10/04/sicp-section-333

(load "ch3/make-table.scm")

(define (fib n)
  (cond ((= n 0) 0)
    ((= n 1) 1)
    (else (+ (fib (- n 1)) (fib (- n 2))))))

(define (memoize f)
  (let ((table (make-table)))
    (lambda (x)
      (let ((previously-computed-result
              (lookup x table)))
        (or previously-computed-result
          (let ((result (f x)))
            (insert! x result table)
            result))))))

(define memo-fib
(memoize
(lambda (n)
(cond ((= n 0) 0)
((= n 1) 1)
(else (+ (memo-fib (- n 1))
(memo-fib (- n 2))))))))


;(begin
;  (fib 32)
;  (runtime)
;  )
; slow. Commented out because runtime is cumulative (not reset by another function call).

(define fib (memoize fib))

(begin
  (fib 32)
  (runtime)
  )

(begin
  (memo-fib 32)
  (runtime)
  )
