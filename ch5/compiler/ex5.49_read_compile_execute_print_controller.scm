;> Design a register machine that performs a read-compile-execute-print loop.


; The plan: compile/assemble as operations.
; read--print-loop: similar to the existing repl
; compile-execute part: use the op, put the resulting code in val, jump to val.
; Compile with linkage return, and (assign continue (label print-result))
(define rcepl-controller
  '(
     read-compile-execute-print-loop
     (perform (op initialize-stack))
     (assign env (op get-global-environment))

     (perform (op prompt-for-input) (const ";;; Read-Compile-Execute input:"))
     (assign exp (op read))

     (assign continue (label print-result))
     (assign val (op compile-and-more) (reg exp))
     (goto (reg val))

     print-result
     (perform (op print-stack-statistics))
     (perform (op announce-output) (const ";;; Read-Compile-Execute value:"))
     (perform (op user-print) (reg val))
     (goto (label read-compile-execute-print-loop))
     )
  )


