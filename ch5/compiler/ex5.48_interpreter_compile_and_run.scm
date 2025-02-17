; this does not have any imports because it's loaded in a ch4/.. file.
; I don't want to break previous exercises by adding side effects, so this just assumes the loading code did load everything needed.
(define (interpreter-compile-and-run expression)
  ; same method as compile-and-go, just as a primitive, and without resetting the environment.
  (let ((instructions (assemble (statements (compile expression 'val 'return the-empty-compiler-environment)) eceval)))
    (set-register-contents! eceval 'val instructions)
    (set-register-contents! eceval 'flag #t)
    (start eceval)
    )
  )


; This is actually pretty tricky:
; (start eceval) will *interrupt* the current execution flow.
; It runs inside the (op apply-primitive-procedure) line, and resets the program counter register.
; we jump to the start of the instructions again.
; the stack gets reset in the repl code (external-entry) so it's ok to skip the restore.
; I added a print before 'restore continue' and it does not get triggered by compile-and-run when inside the repl.
;     primitive-apply
;     (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;     (restore continue)
;     (goto (reg continue))


; At first I thought we *had* to append to the machine instructions to run the compiled code.
; But we don't! when we execute a definition (with instructions in 'val) the procedure stores its code.
; it lives in the environment. Jumping to the compiled proc happens with a (goto (reg x)) that sets the instruction
; list based on the one in reg x, that was initially stored in the compiled procedure object.
