; note it is an error to call append! with an empty list
; we could make the function work but it would not mutate x anymore, which would make for an inconsistent api.
(define (append! x y)
  (set-cdr! (last-pair x) y)
  x
  )

(define (last-pair x)
  (if (null? (cdr x))
    x
    (last-pair (cdr x))
    )
  )

(define x '(a b))
(define y '(c d))
(define z (append x y))

(cdr x)
; expected: (b)

(define w (append! x y))
(cdr x)
; expected: (b c d)

; Box and pointer diagrams:
; x: [ |-]-->[ |/]
;     a       b
; y: [ |-]-->[ |/]
;     c       d
; z: [ |-]-->[ |-]-->[ |-]-->[ |/]
;     a       b       c       d
; w: same as x that was changed to:
; x: [ |-]-->[ |-]---
;     a       b     |
; -------------------
; |
; -->[ |-]-->[ |/]
;     c       d

; Really that's just the same thing as z. I tried to make it look like we were 'plugging' x and y.
