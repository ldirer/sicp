; c. One stack for each register.
; The changes are not very large but they affect a lot of procedures.

; removed the `stack` argument that was passed everywhere. Now the relevant stack is accessed through the machine object.
(define (update-insts! insts labels machine)
  (let (
         (pc (get-register machine 'pc))
         (flag (get-register machine 'flag))
         (ops (machine 'operations))
         )
    ; augment the instruction objects inside the instructions list (with mutation)
    (for-each
      (lambda (inst)
        (set-instruction-execution-proc!
          inst
          (make-execution-procedure (instruction-text inst) labels machine pc flag ops)
          )
        )
      insts
      )
    insts
    )
  )


(define (make-execution-procedure inst labels machine pc flag ops)
  (cond
    ((assign-inst? inst) (make-assign inst machine labels ops pc))
    ((eq? (car inst) 'test) (make-test inst machine labels ops flag pc))
    ((eq? (car inst) 'branch) (make-branch inst machine labels flag pc))
    ((eq? (car inst) 'goto) (make-goto inst machine labels pc))
    ((eq? (car inst) 'save) (make-save inst machine pc))
    ((eq? (car inst) 'restore) (make-restore inst machine pc))
    ((eq? (car inst) 'perform) (make-perform inst machine labels ops pc))
    (else (error "Unknown instruction type -- ASSEMBLE" inst))
    )
  )


; stack instructions: save, restore look up the relevant register stack
(define (make-save inst machine pc)
  (define reg-name (stack-inst-reg-name inst))
  (define stack (get-reg-stack machine reg-name))
  (let ((reg (get-register machine reg-name)))
    (lambda ()
      (push stack (get-contents reg))
      (advance-pc pc)
      )
    )
  )

(define (make-restore inst machine pc)
  (define reg-name (stack-inst-reg-name inst))
  (define stack (get-reg-stack machine reg-name))
  (let ((reg (get-register machine reg-name)))
    (lambda ()
      (set-contents! reg (pop stack))
      (advance-pc pc)
      )
    )
  )

(define (get-reg-stack machine reg-name)
  ((machine 'get-stack) reg-name)
  )

; we store register stacks in another association list in make-new-machine
; the 'stack method is gone, replaced with a 'get-stack (expects a reg-name argument).
(define (make-new-machine)
  (let (
         (pc (make-register 'pc))
         (flag (make-register 'flag))
         (the-instruction-sequence '())
         )
    ; nesting of let... a bit annoying. We could use let* but I'll stick with the book version.
    (let (
           (the-ops
             (list
               ; initialize-stack was never used. I think it's a convenience, porting it anyway.
               (list 'initialize-stacks (lambda () (for-each (lambda (stack-entry) ((cdr stack-entry) 'initialize)))))
               )
             )
           (register-table
             (list (list 'pc pc) (list 'flag flag))
             )
           (stack-table
             (list (list 'pc (make-stack)) (list 'flag (make-stack))))
           )
      (define (allocate-register name)
        (if (assoc name register-table)
          (error "Multiply defined register: " name)
          (set! register-table
            (cons (list name (make-register name)) register-table)))


        (if (assoc name stack-table)
          (error "Already a stack with this name, cannot allocate register stack: " name)
          (set! stack-table (cons (list name (make-stack)) stack-table))
          )
        'register-allocated
        )

      (define (lookup-register name)
        (let ((val (assoc name register-table)))
          (if val
            (cadr val)
            (error "Unknown register: " name)
            )
          )
        )
      (define (lookup-stack name)
        (let ((val (assoc name stack-table)))
          (if val
            (cadr val)
            (error "Unknown stack: " name)
            )
          )
        )

      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
            'done
            (begin
              ((instruction-execution-proc (car insts)))
              (execute)
              )
            )
          )
        )

      (define (dispatch message)
        (cond
          ((eq? message 'start)
            (set-contents! pc the-instruction-sequence)
            (execute))
          ((eq? message 'install-instruction-sequence) (lambda (seq) (set! the-instruction-sequence seq)))
          ((eq? message 'allocate-register) allocate-register)
          ((eq? message 'get-register) lookup-register)
          ((eq? message 'get-stack) lookup-stack)
          ; this is an append. But since the-ops is an assoc list new values will clobber old ones.
          ((eq? message 'install-operations) (lambda (ops) (set! the-ops (append the-ops ops))))
          ((eq? message 'operations) the-ops)
          (else (error "Unknown request -- MACHINE" message))
          )
        )
      dispatch
      )
    )
  )

