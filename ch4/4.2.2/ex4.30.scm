(define (for-each proc items)
  (if (null? items)
    'done
    (begin
      (proc (car items))
      (for-each proc (cdr items))
      )
    )
  )

(for-each
  (lambda (x) (newline) (display x))
  '(57 321 88)
  )

; a. indeed this behaves as intended. Not sure what to explain... Calling the lambda is enough to produce the side effect.

(define (p1 x)
  (set! x (cons x '(2)))
  x
  )

(define (p2 x)
  (define (p e)
    e
    x
    )
  (p (set! x (cons x '(2))))
  )

(p1 1)
; <response 1>

(p2 1)
; <response 2>

;b. Prediction, with original `eval-sequence`:
; Response 1: (1 2)
; Response 2: 1
; -> confirmed
; This is pretty unintuitive indeed...
; With Cy's proposed change, it would be:
; Response 1: (1 2)
; Response 2: (1 2)
; which seems more reasonable (at least in this example!).

; Cy's proposal
(define (eval-sequence exprs env)
  (cond
    ((last-exp? exprs) (eval (first-exp exprs) env))
    (else
      (actual-value (first-expr exprs) env)  ; this changed from eval to actual-value
      (eval-sequence (rest-exprs exprs) env)
      )
    )
  )

; original for comparison
;(define (eval-sequence exprs env)
;  (cond
;    ((last-expr? exprs) (eval (first-expr exprs) env))
;    (else
;      (eval (first-expr exprs) env)
;      (eval-sequence (rest-exprs exprs) env)
;      )
;    )
;  )


;c. Cy's proposal does not change behavior in the first example: the result of the 'lambda' call will be forced, but that's not a thunk so it's a no-op.

;d. I think Cy's approach is more predictable than the one in the text. Makes things easier to reason about.
; Haskell has another approach, closer to the book's I'd say: some side effects do have to be forced. See sibling file for an example.
