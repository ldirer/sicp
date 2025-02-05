; note this file *launches a REPL*
; usage: rlwrap scheme --load "ch5/compiler/compile_and_go_test.scm"
(load "ch5/compiler/compile_and_go.scm")

(compile-and-go
  '(begin
     (define (factorial n)
       (if (= n 1)
         1 (* (factorial (- n 1)) n))
       )

     ;; crashes as expected, though I am not sure how the correct env is used in evaluating the x operand in (+ (f 2) x)...
     ;; _almost_ as expected because the error handling is not properly used in compiled code, we see:
     ;; ;The object (unbound-variable-error), passed as the second argument to integer-add, is not the correct type.
     (define (f x) (+ x 1))
     (+ (f 2) x)
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