(load "ch5/assembler.scm")
; registers
; note name isn't used... even in the error message :)
(define (make-register name)
  (let ((contents '*unassigned*))
    (define (dispatch message)
      (cond
        ((eq? message 'get) contents)
        ((eq? message 'set) (lambda (value) (set! contents value)))
        (else (error "Unknown request -- REGISTER" message))
        )
      )
    dispatch
    )
  )


(define (get-contents register) (register 'get))
(define (set-contents! register value) ((register 'set) value))


; stack
(define (make-stack)
  (let ((s '()))

    (define (push x)
      (set! s (cons x s))
      )

    (define (pop)
      (if (null? s)
        (error "Empty stack -- POP")
        (let ((top (car s)))
          (set! s (cdr s))
          top
          )
        )
      )

    (define (initialize)
      (set! s '())
      'done
      )

    (define (dispatch message)
      (cond
        ; similar to how we deal with set/get messages above. one returns a function.
        ; The other just does the thing. Feels like currying.
        ((eq? message 'push) push)
        ((eq? message 'pop) (pop))
        ((eq? message 'initialize) (initialize))
        (else (error "Unknown request -- STACK" message))
        )
      )

    dispatch
    )
  )


(define (pop stack) (stack 'pop))
(define (push stack value) ((stack 'push) value))



; Basic machine model (figure 5.13)
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
          (else (error "Unknown request -- MACHINE" message))
          )
        )
      dispatch
      )
    )
  )



; Machine model
(define (make-machine register-names ops controller-text)
  (let ((machine (make-new-machine)))
    (for-each (lambda (register-name)
                ((machine 'allocate-register) register-name))
      register-names)
    ((machine 'install-operations) ops)
    ((machine 'install-instruction-sequence)
      (assemble controller-text machine))
    machine
    )
  )


(define (get-register machine reg-name) ((machine 'get-register) reg-name))

(define (get-register-contents machine register-name)
  (get-contents (get-register machine register-name))
  )
(define (set-register-contents! machine register-name value)
  (set-contents! (get-register machine register-name) value)
  'done
  )
(define (start machine) (machine 'start))
