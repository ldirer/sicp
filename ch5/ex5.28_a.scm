;use eceval not tail recursive
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
;(total-pushes = 144 maximum-depth = 23)

(factorial 4)
;(total-pushes = 181 maximum-depth = 26)

(factorial 5)
;(total-pushes = 218 maximum-depth = 29)

(factorial 6)
;(total-pushes = 255 maximum-depth = 32)

(factorial 7)
;(total-pushes = 292 maximum-depth = 35)
