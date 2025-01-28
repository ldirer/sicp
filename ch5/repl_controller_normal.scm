; thunk: procedure, env
; evaluated-thunk: value
; change procedure application. Primitive functions use forced values. Compound procedures use delayed arguments.
; the final value should be forced.

; changed lines indicated by an inline comment (except for the prompt strings).
(define repl-controller
  '(
     read-eval-print-loop
     (perform (op initialize-stack))
     (perform (op prompt-for-input) (const ";;; EC-Eval NORMAL ORDER input:"))
     (assign exp (op read))
     (assign env (op get-global-environment))
     (assign continue (label print-result))

     (perform (op debug-print) (const "go to dispatch, exp=") (reg exp))
     (goto (label eval-dispatch))

     print-result
     (perform (op debug-print) (const "about to force value"))
     (assign argl (reg val))
     (assign continue (label after-force-it))
     (goto (label force-it))

     after-force-it
     (perform (op print-stack-statistics))
     (perform (op announce-output) (const ";;; EC-Eval NORMAL ORDER value:"))
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