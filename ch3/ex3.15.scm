(define x '(a b))
(define z1 (cons x x))
(define z2 (cons '(a b) '(a b)))

(define (set-to-wow! x)
  (set-car! (car x) 'wow)
  x)
(set-to-wow! z1)
(set-to-wow! z2)


; pointer and box diagram. z1 and z2 both represent ((a b) a b)

; z1 (x was inlined):
;    [ |-]-->[ |-]-->[ |/]
;     |     ^ a       b
;     |     |
;     -------
; z2:
;    [ |-]-->[ |-]-->[ |/]
;     |       a       b
;     v
;    [ |-]-->[ |/]
;     a       b
; This explains the behavior of 'set-to-wow!': (car z1) is also (cdr z1) (same pointer), so changing one changes both of them.

