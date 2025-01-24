;use eceval not tail recursive
(define (factorial n)
  (if (= n 1)
    1
    (* (factorial (- n 1)) n)
    )
  )


; RECURSIVE
(factorial 3)
;(total-pushes = 86 maximum-depth = 27)

(factorial 4)
;(total-pushes = 120 maximum-depth = 35)

(factorial 5)
;(total-pushes = 154 maximum-depth = 43)

(factorial 6)
;(total-pushes = 188 maximum-depth = 51)

(factorial 7)
;(total-pushes = 222 maximum-depth = 59)

;; ITERATIVE VERSION - REMINDER (not really iterative *now*)
;(factorial 3)
;;(total-pushes = 144 maximum-depth = 23)
;
;(factorial 4)
;;(total-pushes = 181 maximum-depth = 26)
;
;(factorial 5)
;;(total-pushes = 218 maximum-depth = 29)
;
;(factorial 6)
;;(total-pushes = 255 maximum-depth = 32)
;
;(factorial 7)
;;(total-pushes = 292 maximum-depth = 35)

;the table - Without tail recursion
;                      Maximum depth             Number of pushes
;Recursive factorial   8 * n + 3                 34 * n - 16
;Iterative factorial   3 * n + 14                36 * n + 33


; We do see that both versions now require space growing linearly with input.