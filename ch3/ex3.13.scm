
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


(define z (make-cycle '(a b c)))

; pointer and box diagram
; x: [ |-]-->[ |-]-->[ |/]
;     a       b       c
; After assignment:
; x:
;  -->[ |-]-->[ |-]-->[ |-]---
;  |   a       b       c     |
;  |                         |
;  ---------------------------




; this never terminates:
;(last-pair z)
