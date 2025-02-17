(load "ch5/compiler/compile_and_run.scm")

; I think we would need a setup step to compile and 'load' code without counting stack operations.
; But the definition of factorial does not use any stack operations.
; So we can use a (begin ...) to count accurately.
(define (factorial-stats n)
  (define result '*undefined*)

  (define (set-result stats) (set! result stats))
  (compile-and-run
    `(begin
       (define (factorial n)
         (if (= n 1)
           1
           (* (factorial (- n 1)) n)
           )
         )
       (factorial ,n)
       )
    set-result
    )
  result
  )

(map factorial-stats (list 6 7 8 9))
;Value: ((stack-statistics 10 10) (stack-statistics 12 12) (stack-statistics 14 14) (stack-statistics 16 16))
; this is exactly the same as the special-purpose factorial machine (2 * (n-1)).

;The difference between this and 'compile-and-go' is explained in the other file (noop test).
