; use eceval

; I originally wrote that in an attempt to use `eval` for the normal order version of the EC evaluator (ex5.25).
; That was not helpful: having `eval` available in the code *here* (run by eceval) would let us
; define force-it and co here, but that would not give us the normal order evaluator.
; Basically we would need to rewrite the metacircular interpreter here :).
; To change the way the eceval works to use normal order, we need to call force-it and co in the controller code.
; If they are implemented as operations, they **cannot use our eceval `eval` version**.
; Primitives also cannot use our eceval `eval`, since they are run by the underlying Scheme interpreter, just like operations.
; At the end of the day, implementing eval is not very useful.
; It was interesting to think about how to call the eval function defined in controller code from outside the controller though.
; (I settled for a special 'internal-eval' variable that lives outside environments, similar to a keyword)

(define a the-global-environment)

(eval '(+ 1 1) a)

(define (f)
  (define b (eval '(+ 1 1) a))
  (+ b 1)
  )

(f)
