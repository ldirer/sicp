;use eceval
(define (factorial n)
  (define (iter product counter)
    (if (> counter n)
      product
      (iter
        (* counter product)
        (+ counter 1))
      )
    )
  (iter 1 1)
  )


(factorial 3)
(factorial 4)
(factorial 5)
(factorial 6)
(factorial 7)


;total pushes: 134 169 204 239 274
; Formula for total pushes: n * 35 + 29
; max depth is 10. It is constant because we have tail recursion.
; I think max depth is achieved when evaluating the (* counter product) argument.

;ax1+b=y1
;ax2+b=y2
;a = 169 - 134 = 35
;b = 134 - 3 * 35 = 29

;;;; EC-Eval input:
;(factorial 3)
;(total-pushes = 134 maximum-depth = 10)
;;;; EC-Eval value:
;6
;
;;;; EC-Eval input:
;(factorial 4)
;(total-pushes = 169 maximum-depth = 10)
;;;; EC-Eval value:
;24
;
;;;; EC-Eval input:
;(factorial 5)
;(total-pushes = 204 maximum-depth = 10)
;;;; EC-Eval value:
;120
;
;;;; EC-Eval input:
;(factorial 6)
;(total-pushes = 239 maximum-depth = 10)
;;;; EC-Eval value:
;720
;
;;;; EC-Eval input:
;(factorial 7)
;(total-pushes = 274 maximum-depth = 10)
;;;; EC-Eval value:
;5040