; Breakpoints!
; Multiple new things are needed here:
; 1. line numbers. Relative to labels?...
; Let's say only one combination is valid. label-a 4 cannot be the same as label-b 2.
; 2. The machine can stop early. I think this is a minor change.
; 3. The machine state includes breakpoints.

; Approach: store the line number on the instruction object.
; When executing we check if the line number on the instruction matches one of the breakpoints.
; This does not seem optimal... this slows down every instruction with each breakpoint we add.
; Let's get something working first.

(define (make-instruction text preceding-label label-offset) (list text preceding-label label-offset))
(define (instruction-text inst) (car inst))
(define (instruction-preceding-label inst) (cadr inst))
; aka line number from label
(define (instruction-label-offset inst) (caddr inst))
(define (instruction-execution-proc inst) (cdddr inst))
(define (set-instruction-execution-proc! inst proc) (set-cdr! (cddr inst) proc))

(define (extract-labels text receive)
  (define (helper text receive preceding-label label-offset)
    (if (null? text)
      (receive '() '())
      (let ((next-inst (car text)))
        (let ((is-label (symbol? next-inst)))
          (helper
            (cdr text)
            ; the way I understand it this will build a big stack of closures. One for each instruction.
            ; not very different from a recursive process I guess.
            ; We build the instruction list *from the end*. this is relevant to the make-label-entry call
            ; (we want it to use the list of instructions starting after the label).
            (lambda (insts labels)
              (if is-label
                (receive
                  insts
                  (add-unique-label (make-label-entry next-inst insts) labels)
                  )
                (receive (cons (make-instruction next-inst preceding-label label-offset) insts) labels)
                )
              )
            (if is-label next-inst preceding-label)
            (if is-label 1 (+ label-offset 1))
            )
          )
        )
      )
    )
  ; if there is no label at the start, use "nil".
  ; But ah! it turns out 'controller acts as a label in the examples I use. I thought it was not passed along.
  (helper text receive '() 1)
  )




; set a breakpoint before the n-th instruction after the given label.
(define (set-breakpoint machine label n)
  ((machine 'set-breakpoint) (make-breakpoint label n))
  )
(define (cancel-breakpoint machine label n)
  ((machine 'cancel-breakpoint) (make-breakpoint label n))
  )
(define (cancel-all-breakpoints machine) (machine 'cancel-all-breakpoints))


(define (make-breakpoint label n) (cons label n))
(define (breakpoint-label bp) (car bp))
(define (breakpoint-line bp) (cdr bp))

(define (proceed-machine machine) (machine 'proceed))


(define (make-new-machine)
  (let (
         (pc (make-register 'pc))
         (flag (make-register 'flag))
         (stack (make-stack))
         (the-instruction-sequence '())
         (breakpoints '())
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

      (define (lookup-breakpoint inst)
        (newline)
        (display "inst at ")
        (display (instruction-preceding-label inst))
        (display ":")
        (display (instruction-label-offset inst))
        (define maybe-breakpoint (make-breakpoint (instruction-preceding-label inst) (instruction-label-offset inst)))
        (if (member maybe-breakpoint breakpoints equal?)
          maybe-breakpoint
          #f
          )
        )

      (define (stop-at-breakpoint bp)
        (newline)
        (display "hit breakpoint at ")
        (display (breakpoint-label bp))
        (display ":")
        (display (breakpoint-line bp))
        )

      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
            'done
            (let ((inst (car insts)))
              (let ((matching-breakpoint (lookup-breakpoint inst)))
                (if matching-breakpoint
                  (stop-at-breakpoint matching-breakpoint)
                  (begin
                    ((instruction-execution-proc inst))
                    (execute)
                    )
                  )
                )
              )
            )
          )
        )

      ; need this procedure to force executing the next step (and get out of the breakpoint)
      (define (proceed)
        (let ((insts (get-contents pc)))
          (if (null? insts)
            'already-done
            (let ((inst (car insts)))
              ((instruction-execution-proc inst))
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
          ((eq? message 'proceed) (proceed))
          ((eq? message 'install-instruction-sequence) (lambda (seq) (set! the-instruction-sequence seq)))
          ((eq? message 'allocate-register) allocate-register)
          ((eq? message 'get-register) lookup-register)
          ; this is an append. But since the-ops is an assoc list new values will clobber old ones.
          ((eq? message 'install-operations) (lambda (ops) (set! the-ops (append the-ops ops))))
          ((eq? message 'stack) stack)
          ((eq? message 'operations) the-ops)
          ((eq? message 'set-breakpoint) (lambda (bp) (set! breakpoints (cons bp breakpoints))))
          ((eq? message 'cancel-breakpoint) (lambda (bp)
                                              (set! breakpoints
                                                (filter (lambda (item) (not (equal? item bp))) breakpoints))
                                              ))
          ((eq? message 'cancel-all-breakpoints) (set! breakpoints '()))
          (else (error "Unknown request -- MACHINE" message))
          )
        )
      dispatch
      )
    )
  )
