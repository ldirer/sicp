; > Registers should accept messages that turn tracing on and off.
; > When a register is traced, assigning a value to the register should print the name of the register,
; > the old contents of the register, and the new contents being assigned.

; > Extend the interface to the machine model to permit you to turn tracing on and off for designated machine registers.

; I did not add an operation for that, so tracing cannot be toggled inside the machine code.
; That could be a nice addition for more targeted debugging. Not sure I'll really use that so I didn't do it.

; This is where we finally use the `name` argument :)
(define (make-register name)
  (let ((contents '*unassigned*)
         (trace #f))

    (define (display-trace value)
      (newline)
      (display name)
      (display ": ")
      (display contents)
      (display "<-")
      (display value)
      )

    (define (set value)
      (if trace (display-trace value))
      (set! contents value)
      )

    (define (dispatch message)
      (cond
        ((eq? message 'get) contents)
        ((eq? message 'set) set)
        ((eq? message 'trace-on) (set! trace #t))
        ((eq? message 'trace-off) (set! trace #f))
        (else (error "Unknown request -- REGISTER" message))
        )
      )
    dispatch
    )
  )



(define (trace-register machine reg-name on?)
  (define reg (get-register machine reg-name))
  (if on?
    ((machine 'trace-register-on) reg)
    ((machine 'trace-register-off) reg)
    )
  )


(define (make-new-machine)
  (let (
         (pc (make-register 'pc))
         (flag (make-register 'flag))
         (stack (make-stack))
         (the-instruction-sequence '())
         )
    ; nesting of let... a bit annoying. We could use let* but I'll stick with the book version.
    (let (
           (the-ops
             (list
               (list 'initialize-stack (lambda () (stack 'initialize)))
               (list 'print-stack-statistics (lambda () (stack 'print-statistics)))
               )
             )
           (register-table
             (list (list 'pc pc) (list 'flag flag))
             )
           )
      (define (allocate-register name)
        (if (assoc name register-table)
          (error "Multiply defined register: " name)
          (set! register-table
            (cons (list name (make-register name)) register-table)))
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
          ; this is an append. But since the-ops is an assoc list new values will clobber old ones.
          ((eq? message 'install-operations) (lambda (ops) (set! the-ops (append the-ops ops))))
          ((eq? message 'stack) stack)
          ((eq? message 'operations) the-ops)
          ((eq? message 'trace-register-on) (lambda (reg) (reg 'trace-on)))
          ((eq? message 'trace-register-off) (lambda (reg) (reg 'trace-off)))
          (else (error "Unknown request -- MACHINE" message))
          )
        )
      dispatch
      )
    )
  )
