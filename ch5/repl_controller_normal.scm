; thunk: procedure, env
; evaluated-thunk: value
; change procedure application. Primitive functions use forced values. Compound procedures use delayed arguments.
; the final value should be forced: that means a change in the repl controller?

; TODO how do I reference eval in actual-value??
; If actual-value is written in controller code, this means bringing force-it in??
; Or how does it call actual-value?
; How does ANYTHING call actual-value if it's written in controller code?
; ... With that line of reasoning we writing a lot of stuff in controller code.
; maybe it requires adding an 'eval?' line in the dispatch.

; changed lines indicated by an inline comment (except for the prompt strings).
(define repl-controller
  '(
     read-eval-print-loop
     (perform (op initialize-stack))
     (perform (op prompt-for-input) (const ";;; EC-Eval NORMAL ORDER input:"))
     (assign exp (op read))
     (assign env (op get-global-environment))
     (assign continue (label print-result))
     (goto (label eval-dispatch))

     print-result
     (assign val (op force-it) (reg val))                                               ; CHANGED LINE
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