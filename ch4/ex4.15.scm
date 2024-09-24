

; Assuming we have a `halts?` procedure taking as input a procedure and one argument, returning true if the procedure
; eventually halts, false otherwise.
;

; this one does not halt.
(define (run-forever) (run-forever))

(define (try p)
  (if (halts? p p)
    (run-forever)
    true
    )
  )


; Now considering (halts? try try)
; 1. If it's true, then (try try) goes into the `(run-forever)` branch. And it does *not* halt,
; meaning `(halts? try try)` should evaluate to false to be correct: contradiction.
; 2. If it's false, then (try try) goes into the `true` branch. It returns (halts), contradicting the result of `(halts? try try)`.
; This proves that a general `halts?` procedure as described cannot exist: this is Turing's Halting Theorem!
