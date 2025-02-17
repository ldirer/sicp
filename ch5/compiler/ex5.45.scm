;(load "ch5/compiler/compile_and_run.scm")
(load "ch5/compiler/compile_and_go.scm")
; 5.27: determine number of pushes/stack depth needed by the evaluator to compute n!
; 5.14: same thing for the special-purpose factorial machine

; ex5.14:
; total pushes = 2 * (n - 1).
; max depth = 2 * (n - 1).

; ex5.27:
;                      Maximum depth             Number of pushes
;Recursive factorial   5 * n + 3                 32 * n - 16
;Iterative factorial   10                        35 * n + 29

; Results here:
; total pushes: 2 * n + 3
; max depth = 2 * (n - 1)

;; this is very close to the special-purpose factorial machine!
;; That confused me at first. The exercise seemed to hint that there was a large difference.
;; That's because I had open-coded primitives enabled.
;; Without it:
; total pushes = 6 * n + 1
; max depth = 3 * n - 1
; That is a huge difference!!


(set! FLAGS (cons (cons 'open-coded-primitives #f) FLAGS))


(compile-and-go
  '(begin
     (define (factorial n)
       (if (= n 1)
         1
         (* (factorial (- n 1)) n)
         )
       )
     (define (noop n) 'ok)
     )
  )

(factorial 6)
(factorial 7)
(factorial 8)

;; WITH OPEN CODED PRIMITIVES
;(factorial 6)
;(total-pushes = 15 maximum-depth = 10)
;(factorial 7)
;(total-pushes = 17 maximum-depth = 12)
;(factorial 8)
;(total-pushes = 19 maximum-depth = 14)


;; WITHOUT OPEN CODED PRIMITIVES
;(factorial 6)
;(total-pushes = 37 maximum-depth = 17)
;(factorial 7)
;(total-pushes = 43 maximum-depth = 20)
;(factorial 8)
;(total-pushes = 49 maximum-depth = 23)



;; This explains the difference between compile-and-run and compile-and-go.
; the eceval code uses 5 pushes evaluating a function with 1 argument.
; in (factorial 5) that means 5 pushes before we reach the compiled code.
;(noop 1)
;;(noop 1)
;;(total-pushes = 5 maximum-depth = 3)



;b. For further optimizations, https://www.inchmeal.io/sicp/ch-5/ex-5.45.html writes:
; > I think it is quite difficult to deduce that which registers a compound procedure modifies and
; > thus avoiding there save and restores.
; I don't understand that statement?
; I would say our compiler already covers that with `preserving`. The body of a compound procedure does not modify registers in my understanding?
; It's the controller code generated around it. To evaluate arguments and stuff. But that's handled with `preserving`.
; -> I'm not crystal-clear on that.
; Chat said the statement might hold truth if a procedure is called indirectly (passed as argument to a 'higher-order' procedure).
; Then I convinced it to say the other thing, so I don't know :).
;https://chatgpt.com/c/67b25d10-c1d8-8006-881c-a72ef385ae7c

; inchmeal also mentions choosing between left-to-right and right-to-left.