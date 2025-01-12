; > Specify register machines (controller instruction sequence and data paths diagram)


; a. Recursive exponentiation

(define (expt b n)
  (if (= n 0)
    1
    (* b (expt b (- n 1))))
  )


'(data-paths
  (registers
    ((name b) (buttons))
    ((name n) (buttons ((name n<-n-1) (source (operation -)))))
    ; need a register to store the return value
    ((name val) (buttons
                  ((name val<-base) (source (constant 1)))
                  ((name val<-next) (source (operation *)))
                  ))
    ; need a register to continue, and a stack to save values through recursion.
    ; sc/rc: save c, restore c. Stack operations, uses stack registers.
    ; I am not sure how to fit this nicely in here because we don't name the stack registers that would 'host' these buttons.
    ; I made a 'stack' register, I think it's consistent with how we draw diagrams.
    ; The data-paths spec does not show exactly when/how rc and sc are used, I think this is normal.
    ; it's part of the controller spec.
    ; Also not sure where to put the 'assign continue (label xx)' operations.
    ; Probably buttons with constants? I tried that.
    ((name continue)
      (buttons
        ((name rc) (source (register stack)))
        ((name c<-done) (source (constant label-done)))
        ((name c<-after-recursive-call) (source (constant label-after-recursive-call)))
        ))
    ((name stack)
      (buttons ((name sc) (source (register continue))))
      )
    )

  (operations
    ((name =) (inputs (register n) (constant 0)))
    ((name -) (inputs (register n) (constant 1)))
    ((name *) (inputs (register b) (register val)))
    )

  )

; controller
(define recursive-controller '(controller
  (assign continue (label expt-done))

  expt-loop
  (test (op =) (reg n) (const 0))
  (branch (label expt-base-case))
  ; recursive case
  (save continue)   ; save who called us. Will be restored after we are done in this 'recursive level'

  (assign n (op -) (reg n) (const 1))
  (assign continue (label expt-after-recursive-call))
  (goto (label expt-loop))

  expt-after-recursive-call
  ; do this first so we don't forget
  (restore continue)
  (assign val (op *) (reg b) (reg val))
  ; return a value: control back to caller
  (goto (reg continue))

  expt-base-case
  (assign val (const 1))   ; val<-base
  (goto (reg continue))  ; key! return to caller
  expt-done
  ))


; b. Iterative exponentiation
(define (expt b n)
  (define (expt-iter counter product)
    (if (= counter 0)
      product
      (expt-iter (- counter 1) (* b product)))
    )
  (expt-iter n 1)
  )


'(data-paths
  (registers
    ((name b) (buttons))
    ; register n doubles as counter.
    ; Hmmm but if n was actually used later on we could not do that.
    ; It's an optimization I guess, not using it for now.
    ((name n) (buttons
                ((name n<-n-1) (source (operation -)))
                ))
    ((name count)
      (buttons
        ((name count<-count-1) (source (operation -)))
        ((name count<-init) (source (register n)))
        )
      )
    ; product - named val to compare with the recursive version.
    ((name val)
      (buttons
        ((name val<-next) (source (operation *)))
        ((name val<-init) (source (constant 1)))
        )
      )
    )

  (operations
    ((name =) (inputs (register count) (constant 0)))
    ((name -) (inputs (register count) (constant 1)))
    ((name *) (inputs (register b) (register val)))
    )
  )

(define iterative-controller '(controller
  (assign val (const 1))   ; val<-base
  (assign count (reg n))
  expt-loop
  (test (op =) (reg count) (const 0))
  (branch (label expt-done))
  ; recursive case
  (assign count (op -) (reg count) (const 1))
  (assign val (op *) (reg b) (reg val))
  (goto (label expt-loop))
  expt-done
  ))

; The iterative process version is much simpler indeed.