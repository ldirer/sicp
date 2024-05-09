; not tested.

; the design of the program has been done for us.
; it's the hardest part ! Looks simple but it's a lot more subtle than it looks.
;(get-signal wire)
;(set-signal! wire value)
;(add-action! wire procedure)

; also (after-delay time procedure)

(define (or-gate a1 a2 output)

  (define (or-action-procedure)
    (let ((output-value (logical-or a1 a2)))
      (after-delay
        or-gate-delay
        (lambda () (set-signal! output output-value)))
      )
    )

  (add-action! a1 or-action-procedure)
  (add-action! a2 or-action-procedure)
  'ok
  )

(define (logical-or a b)
  (cond
    ((and (= a 0) (= b 0)) 0)
    ((and (= a 1) (= b 0)) 1)
    ((and (= a 0) (= b 1)) 1)
    ((and (= a 1) (= b 1)) 1)
    (else error "wrong boolean table, missing a b=" a b)
    )
  )