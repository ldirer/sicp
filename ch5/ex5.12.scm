; The recording is made separate from the analysis, so the code isn't littered with recording.
(define (inst-type inst) (car inst))

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

      (define recorded (list))

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

          ((eq? message 'install-recorded) (lambda (recorded-obj) (set! recorded recorded-obj)))
          ((eq? message 'recorded) recorded)

          (else (error "Unknown request -- MACHINE" message))
          )
        )
      dispatch
      )
    )
  )

(define (make-analyze-recorded insts)
  (define unique-insts-by-type (list))
  (define entrypoints (list))
  (define saved (list))
  (define restored (list))
  (define assigns-by-register (list))

  (define (process-inst inst)
    (if (not (symbol? inst))
      (let ((inst-type (car inst)))
        (let ((seen-insts (assoc inst-type unique-insts-by-type)))
          (if seen-insts
            (if (not (member inst seen-insts))
              (set-cdr! seen-insts (cons inst (cdr seen-insts)))
              )
            (set! unique-insts-by-type (cons (list inst-type inst) unique-insts-by-type))
            )
          )

        (cond
          ((and (eq? inst-type 'goto) (register-exp? (goto-dest inst)))
            (let ((dest-reg-name (register-exp-reg (goto-dest inst))))
              (if (not (member dest-reg-name entrypoints))
                (set! entrypoints (cons dest-reg-name entrypoints))
                )
              )
            )
          ((eq? inst-type 'assign)
            (let ((reg-name (assign-reg-name inst)))
              (let ((reg-assigns (assoc reg-name assigns-by-register)))
                (if reg-assigns
                  (if (not (member (assign-value-exp inst) (cdr reg-assigns)))
                    (set-cdr! reg-assigns (cons (assign-value-exp inst) (cdr reg-assigns)))
                    )
                  (set! assigns-by-register (cons (cons reg-name (list (assign-value-exp inst))) assigns-by-register))
                  )
                )
              )
            )
          ((eq? inst-type 'save)
            (let ((reg-name (stack-inst-reg-name inst)))
              (if (not (member reg-name saved))
                (set! saved (cons reg-name saved))
                )
              )
            )
          ((eq? inst-type 'restore)
            (let ((reg-name (stack-inst-reg-name inst)))
              (if (not (member reg-name restored))
                (set! restored (cons reg-name restored))
                )
              )
            )
          )
        )
      )
    )
  (for-each process-inst insts)

  ; convert the assoc list to a flat list (sorted by instruction type)
  (define (assoc-pair-symbol<? assoc-pair1 assoc-pair2) (string<? (symbol->string (car assoc-pair1)) (symbol->string (car assoc-pair2))))
  (define unique-insts
    (fold-left append (list) (map cdr (sort unique-insts-by-type assoc-pair-symbol<?)))
    )

  (define (dispatch message)
    (cond
      ((eq? message 'unique-insts) unique-insts)
      ((eq? message 'entrypoints) entrypoints)
      ((eq? message 'saved) saved)
      ((eq? message 'restored) restored)
      ((eq? message 'assigns-by-register) assigns-by-register)
      )
    )
  dispatch

  )


(define (make-machine register-names ops controller-text)
  (let ((machine (make-new-machine)))
    (for-each (lambda (register-name)
                ((machine 'allocate-register) register-name))
      register-names)
    ((machine 'install-operations) ops)
    ((machine 'install-instruction-sequence)
      (assemble controller-text machine))
    ((machine 'install-recorded) (make-analyze-recorded controller-text))
    machine
    )
  )

