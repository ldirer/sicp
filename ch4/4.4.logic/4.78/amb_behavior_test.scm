
(define global-rules (list))
(set! global-rules (cons 1 global-rules))

(define (f)
  (set! global-rules (cons 2 global-rules))
  global-rules
  )

(f)
; wow. The evaluator only backtracks if we exhaust the possibilities.
; that does not seem like a very consistent behavior :).
; Meaning: if we don't `try-again` to exhaustion but *start a new problem instead*, we don't get backtrack.
; that makes sense in the implementation but I'm not so sure it's the best user experience.
try-again

; checking permanent-set! works (not sure if it was in the 'core' code or an exercise).
(define (g)
  (permanent-set! global-rules (cons 3 global-rules))
  global-rules
  )

(g)
try-again
global-rules


; if-fail causes try-again to retry inside its predicate.
; this matters for `negate`.
(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items)))
  )

(if-fail (let ((x (an-element-of '(1 3 5 8 10 12))))
           (require (even? x))
           x)
  'all-odd)
try-again
; expected: 8
