; > `eval` uses `actual-value` rather than `eval` to evaluate the operator before passing it to `apply`,
; > in order to force the value of the operator. Give an example that demonstrates the need for this forcing.

(define (map fn items)
  (if (null? items)
    '()
    (cons (fn (car items)) (map fn (cdr items))))
  )

(define (incr a) (+ a 1))

; In this call, `incr` will be put into a thunk when passed as an argument.
; if we used `eval` instead of `actual-value` we would try to apply  '(thunk incr <root-env>) to 1 when inside map.
(map incr '(1 2 3))
; I tried it after modifying the code to use `eval`:
; LAZY Unknown procedure type -- APPLY LAZY (thunk fn (((fn items) (thunk fn (... . #0=...)) (evaluated-thunk (2 3))) . #0#))