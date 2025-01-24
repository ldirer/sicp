(define repl-controller
  '(
     read-eval-print-loop
     (perform (op initialize-stack))
     (perform (op prompt-for-input) (const ";;; EC-Eval input:"))
     (assign exp (op read))
     (assign env (op get-global-environment))
     (assign continue (label print-result))
     (goto (label eval-dispatch))

     print-result
     (perform (op print-stack-statistics))
     (perform (op announce-output) (const ";;; EC-Eval value:"))
     (perform (op user-print) (reg val))
     (goto (label read-eval-print-loop))

      unknown-expression-type
      (assign val (const unknown-expression-type-error))
      (goto (label signal-error))

      unknown-procedure-type
      (restore continue)               ; clean up stack (from apply-dispatch)
      (assign val (const unknown-procedure-type-error))
      (goto (label signal-error))

      signal-error
      (perform (op user-print) (reg val))
      (goto (label read-eval-print-loop))
     )
  )