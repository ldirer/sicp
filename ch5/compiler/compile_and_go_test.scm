; note this file *launches a REPL*
; usage: rlwrap scheme --load "ch5/compiler/compile_and_go_test.scm"
(load "ch5/compiler/compile_and_go.scm")

(compile-and-go
  '(begin
     (define (factorial n)
       (if (= n 1)
         1 (* (factorial (- n 1)) n))
       )
     )
  )

; I get the same result as the book:
;;;; EC-Eval input:
;(factorial 5)
;(total-pushes = 31 maximum-depth = 14)
;;;; EC-Eval value:
;120

; With open-coded primitives as in ex5.38, we even get:
;;;; EC-Eval input:
;(factorial 5)
;(total-pushes = 13 maximum-depth = 8)
;;;; EC-Eval value:
;120

; compared to 144 pushes and 28 stack depth for the interpreted version!