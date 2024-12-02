; use myamb

(define count 0)

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items)))
  )

(let (
       (x (an-element-of '(a b c)))
       (y (an-element-of '(a b c)))
       )
  (permanent-set! count (+ count 1))
  (require (not (eq? x y)))
  (list x y count)
  )

; expected: (a b 2)

try-again
; expected (a c 3)


; with `set!` we would have seen the values (confirmed by testing):
; (a b 1)
; (a c 1)
; as count updates would have been backtracked.
