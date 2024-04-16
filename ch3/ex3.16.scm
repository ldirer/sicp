(define (count-pairs x)
  (if (not (pair? x))
    0
    (+ (count-pairs (car x))
      (count-pairs (cdr x))
      1))
  )

;    [ |-]-->[ |-]-->[ |/]
;     |     ^ a       b
;     |     |
;     -------
; :
;    [ |-]-->[ |-]-->[ |/]
;     |       a       b
;     v
;    [ |-]-->[ |/]
;     a       b


;    [ |-]-->[ |-]-->[ |/]
;     a       b       c
(count-pairs '(a b c))
;expected: 3

(define x '((a b)))
(set-cdr! x (cdr (car x)))
x
; expected: ((a b) b) (with '(b) a shared pair!...)
(count-pairs x)
;expected: 4
;    [ |-]---
;     |     |
;     v     v
;    [ |-]-->[ |/]
;     a       b

; trying to get a count of 7:
(define shared '(a))
(define x (cons shared '()))
(set-cdr! x shared)
(define x2 (cons x '()))
(set-cdr! x2 x)
x2
x
(count-pairs x2)
; expected: 7


;create a cycle - still 3 pairs.
;  -->[ |-]-->[ |-]-->[ |-]---
;  |   a       b       c     |
;  |                         |
;  ---------------------------
; any cycle would have worked.
(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x
  )

(define (last-pair x)
  (if (null? (cdr x))
    x
    (last-pair (cdr x))
    )
  )
(count-pairs (make-cycle '(a b c)))
;expected: never return/max recursion depth exceeded (in this case, because the procedure isn't tail-recursive).



; SO. I managed to find examples. But the way I'm building them is NOT OK surely. Way too complicated (the way I'm using `set-car!` and `set-cdr!`).

; Cleaner approach below, inspired by https://eli.thegreenplace.net/2007/09/29/sicp-331#fn4
(define x '(a b c))
; make first element point to third pair
(set-car! x (cddr x))
; x: ((c) b c)
(count-pairs x)
;expected: 4
(define x '(a b c))
; make first pair point to second pair
(set-car! x (cdr x))
; make second pair point to third pair
(set-car! (cdr x) (cddr x))
(count-pairs x)
;expected: 7
