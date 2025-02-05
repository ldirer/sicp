; note this file *launches a REPL*
; usage: rlwrap scheme --load "ch5/compiler/ex5.38_compiled_test.scm"
(load "ch5/compiler/compile_and_go.scm")

(compile-and-go
  '(begin
     ;; should crash as expected if env is correctly managed.
     ;; _almost_ as expected because the error handling is not properly used in compiled code, we see:
     ;; ;The object (unbound-variable-error), passed as the second argument to integer-add, is not the correct type.
     (define (f x) (+ x 1))
     (+ (f 2) x)
     )
  )
