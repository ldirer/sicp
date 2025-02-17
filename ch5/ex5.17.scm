; > Extend instruction tracing of exercise 5.16 so that before printing an instruction, the simulator prints
; > any labels that immediately precede that instruction in the controller sequence.
; I was wondering why the text mentioned "be careful to do this in a way that does not interfere with instruction counting".
; ChatLLM mentioned that a seemingly natural approach might be to treat labels as instructions, and adjust the 'execute' proc to print preceding labels.
; Ok, this would indeed break instruction counting.

; --> I gather it prints nothing unless the previous instruction is a label. "any labels": 0 or 1.
; ---> unless there are multiple labels in succession. Not really useful but let's do that.

; How could we have interfered with it? I'm not sure.

; We attach the immediately preceding labels to instructions.
; Reminder: this whole thing is useful because labels are not part of the executed instructions, so they don't already show up in instruction printing.
; This is done by modifying the constructor, adding a new selector and adjusting the 'extract-labels' procedure.
; Then we can add the printing in the machine method.
(define (make-instruction text preceding-labels) (list text preceding-labels))
(define (instruction-text inst) (car inst))
(define (instruction-preceding-labels inst) (cadr inst))
(define (instruction-execution-proc inst) (cddr inst))
(define (set-instruction-execution-proc! inst proc) (set-cdr! (cdr inst) proc))

(define (extract-labels text receive)
  (define (helper text receive preceding-labels)
    (if (null? text)
      (receive '() '())
      (helper
        (cdr text)
        ; the way I understand it this will build a big stack of closures. One for each instruction.
        ; not very different from a recursive process I guess.
        ; We build the instruction list *from the end*. this is relevant to the make-label-entry call
        ; (we want it to use the list of instructions starting after the label).
        (lambda (insts labels)
          (let ((next-inst (car text)))
            (if (symbol? next-inst)
              (receive
                insts
                ; (cons (make-label-entry next-inst insts) labels)
                ; keeping exercise 5.8 extra programing-error handling
                (add-unique-label (make-label-entry next-inst insts) labels)
                )
              (receive (cons (make-instruction next-inst preceding-labels) insts) labels)
              )
            )
          )
        (if (symbol? (car text))
          (append preceding-labels (list (car text)))
          (list)
          )
        )

      )
    )
  (helper text receive '())
  )




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
               (list 'get-stack-statistics (lambda () (stack 'get-statistics)))
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

      (define (print-instruction inst)
        (begin
          (for-each
            (lambda (label) (newline) (display "Preceding label: ") (display label))
            (instruction-preceding-labels inst)
            )

          (newline)
          (display (instruction-text inst))
          )
        )

      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
            'done
            (begin
              (set! instruction-counter (+ instruction-counter 1))
              (if trace
;                (and trace
;                    ; why not: implement trace-filters. useful!! maybe make it a proc with inst as parameter.
;                    (or
;                      (equal? (car (instruction-text (car insts))) 'restore)
;                      (equal? (car (instruction-text (car insts))) 'save)
;                      (equal? (cadr (instruction-text (car insts))) 'continue)
;                      )
;                    )
                (print-instruction (car insts))
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

