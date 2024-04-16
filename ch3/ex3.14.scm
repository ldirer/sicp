(define (mystery x)
  (define (loop x y)
    (if (null? x)
      y
      (let ((temp (cdr x)))
        (set-cdr! x y)
        (loop temp x))))
  (loop x '())
  )
; I'd say mystery reverses the given list inplace.
; --> That is **incorrect**. It returns a new list, reversed version of the original list.
; it also botches up the original list in the process, removing it's 'cdr'.
; that's because of the first call to loop the formal parameter 'x' is bound to the original list. Its cdr is removed with the call to `set-cdr!`.
; then on subsequent calls to loop, we alter the cdr of a different list (temp, then another temp, etc).

(define v '(a b c d))
(define w (mystery v))
v
; (a)
w
; (d c b a)

; skipping box and pointer diagrams.
