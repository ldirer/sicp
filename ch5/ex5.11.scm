; > (restore y) puts into y the last value saved on the stack, regardless of what registe rthat value came from.
; > This is the way our simulator behaves. Show how to take advantage of this behavior to eliminate one instruction from the Fibonacci machine of section 5.1.4.


; The machine. CTRL+F OPTIMIZATION.
'(controller
   (assign continue (label fib-done))

   fib-loop
   (test (op <) (reg n) (const 2))
   (branch (label immediate-answer))
   ; recursive main course

   (save continue)
   (assign continue (label after-fib-n-1))
   (save n)
   (assign n (op -) (reg n) (const 1))
   (goto (label fib-loop))

   after-fib-n-1
   (restore n)
   (restore continue)

   (assign n (op -) (reg n) (const 2))
   ; always save before assigning to continue
   (save continue)
   (assign continue (label after-fib-n-2))

   (save val)

   (goto (label fib-loop))

   after-fib-n-2
   ; OPTIMIZATION USING RESTORE'S BEHAVIOR

   ; Before:
   ; ; use n as a temporary register. We'll restore it later anyway.
   ; ; store the value of (fib (- n 1))
   ; (assign n (reg val))
   ; (restore val)

   ; After:
   ; this puts the saved *val* into the n register.
   ; Basically this swaps n and val compared with the previous version, the later (assign val ..) still works.
   (restore n)
   ; END OPTIMIZATION

   (restore continue)
   (assign val (op +) (reg val) (reg n))
   (goto (reg continue))

   immediate-answer
   (assign val (reg n))
   (goto (reg continue))
   fib-done
   )



; b. Modifying the simulator to signal an error if restoring to a register that isn't the last 'saved' one.
; This was easy to do and makes for a nice debugging tool.

(define (make-stack-saved source-reg val) (cons source-reg val))
(define (stack-saved-reg ss) (car ss))
(define (stack-saved-value ss) (cdr ss))

(define (make-save inst machine stack pc)
  (define reg-name (stack-inst-reg-name inst))
  (let ((reg (get-register machine reg-name)))
    (lambda ()
      (push stack (make-stack-saved reg-name (get-contents reg)))
      (advance-pc pc)
      )
    )
  )

(define (make-restore inst machine stack pc)
  (define dest-reg-name (stack-inst-reg-name inst))
  (let ((reg (get-register machine dest-reg-name)))
    (lambda ()
      (let ((ss (pop stack)))
        (if (not (eq? (stack-saved-reg ss) dest-reg-name))
          (error "tried to restore to a register that was not the last saved one - restore target, last saved:" dest-reg-name (stack-saved-reg ss))
          )
        (set-contents! reg (stack-saved-value ss))
        (advance-pc pc)
        )
      )
    )
  )



; c. One stack for each register