; instruction tracing
(define (make-new-machine)
  (let (
         (pc (make-register 'pc))
         (flag (make-register 'flag))
         (stack (make-stack))
         (the-instruction-sequence '())
         (instruction-counter 0)
         (trace #f)
         )

    (define (print-and-reset-instruction-counter)
      (newline)
      (display "instruction count since last report: ") (display instruction-counter)
      (set! instruction-counter 0)
      )
    ; nesting of let... a bit annoying. We could use let* but I'll stick with the book version.
    (let (
           (the-ops
             (list
               (list 'initialize-stack (lambda () (stack 'initialize)))
               (list 'print-stack-statistics (lambda () (stack 'print-statistics)))
               (list 'print-and-reset-instruction-counter print-and-reset-instruction-counter)
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
              (set! instruction-counter (+ instruction-counter 1))
              (if trace
                (begin
                  (newline)
                  (display (instruction-text (car insts)))
                  )
                )
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
          ((eq? message 'trace-on) (set! trace #t) 'ok)
          ((eq? message 'trace-off) (set! trace #f) 'ok)
          ((eq? message 'operations) the-ops)
          (else (error "Unknown request -- MACHINE" message))
          )
        )
      dispatch
      )
    )
  )
