; use eceval

(define a the-global-environment)

(eval '(+ 1 1) a)

(define (f)
  (define b (eval '(+ 1 1) a))
  (+ b 1)
  )

(f)
