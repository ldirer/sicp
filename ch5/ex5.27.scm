;use eceval
(define (factorial n)
  (if (= n 1)
    1
    (* (factorial (- n 1)) n)
    )
  )


(factorial 3)
(factorial 4)
(factorial 5)
(factorial 6)
(factorial 7)

; Full output below, summary:
;(total-pushes = 80 maximum-depth = 18)
;(total-pushes = 112 maximum-depth = 23)
;(total-pushes = 144 maximum-depth = 28)
;(total-pushes = 176 maximum-depth = 33)
;(total-pushes = 208 maximum-depth = 38)

; Formulas:
; total pushes: 32 * (n - 1) + 16 (or 32 * n - 16)
; maximum depth: 5*n + 3

; in a nice table

;                      Maximum depth             Number of pushes
;Recursive factorial   5 * n + 3                 32 * n - 16
;Iterative factorial   10                        35 * n + 29


;> the maximum depth is a measure of the amount of space used by the evaluator in carrying out the computation, and the number of pushes correlates well with the time required.
; --> Waaaaaat?! That means the iterative version would actually be marginally *slower* than the recursive version?? Crazy to me.
;




;;;; EC-Eval input:
;(factorial 3)
;(total-pushes = 80 maximum-depth = 18)
;;;; EC-Eval value:
;6
;
;;;; EC-Eval input:
;(factorial 4)
;(total-pushes = 112 maximum-depth = 23)
;;;; EC-Eval value:
;24
;
;;;; EC-Eval input:
;(factorial 5)
;(total-pushes = 144 maximum-depth = 28)
;;;; EC-Eval value:
;120
;
;;;; EC-Eval input:
;(factorial 6)
;(total-pushes = 176 maximum-depth = 33)
;;;; EC-Eval value:
;720
;
;;;; EC-Eval input:
;(factorial 7)
;(total-pushes = 208 maximum-depth = 38)
;;;; EC-Eval value:
;5040