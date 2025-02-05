; note this file *launches a REPL*
; usage: rlwrap scheme --load "ch5/compiler/compile_and_go_test.scm"
(load "ch5/compiler/compile_and_go.scm")

(compile-and-go
  '(define (factorial n)
     (if (= n 1)
       1 (* (factorial (- n 1)) n)))
  )