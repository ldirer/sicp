(load "testing.scm")
(load "ch5/compiler/compile_and_run.scm")

; At first I tried to compile the example with 'let'... but the compiler does not handle that!
; gave weird errors.
(check-equal "example from book"
  (compile-and-run
    '(begin
       (define (f)
         (
           (lambda (x y)
             (lambda (a b c d e)
               ((lambda (y z) (* x y z))
                 (* a b x)
                 (+ c d x))
               )
             )
           3 4)
         )
       ((f) 10 20 30 40 50)
       )
    )
  131400   ; result from regular Scheme
  )


(check-equal "simple with global"
  (compile-and-run
    '(begin
       (define c 7)
       ((lambda (a b) (+ a c)) 3 100)
       )
    )
  10
  )