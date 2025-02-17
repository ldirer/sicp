; > spread-arguments should take an operand list and compile the given operands targeted to successive argument registers.
; argument registers: val, arg1, arg2
; > the primitive arithmetic operations will take their inputs from arg1 and arg2. The results may be put in val, arg1, ar2.


(define argument-registers '(arg1 arg2))
(define (spread-arguments operands comp-env)
  (spread-arguments-2 operands argument-registers (list) comp-env)
  )

(define (spread-arguments-2 operands remaining-argument-regs used-argument-regs comp-env)
  (cond
    ((null? operands) (empty-instruction-sequence))
    ((and (null? remaining-argument-regs) (not (null? operands)))
      (error "not enough argument registers, remaining operands -- COMPILE" operands))
    (else
      (let ((operand (car operands)) (arg-reg (car remaining-argument-regs)))
        ; Look at tests (or think about (+ 1 (+ 2 3)) if it's not clear what should be preserved.
        (let ((to-preserve (cons arg-reg used-argument-regs)))
          (preserving
            ; See the (+ (f 2) x) test if it's unclear why env is required.
            ; Originally I skipped preserving env for the last argument, passing '() instead.
            ; after the last argument, we can afford to leave env in whatever state since we don't need it later in this expression.
            ; if the next expression needs it relevant save/restore instructions will be added when combining expressions (with preserving)
            ; --> precisely because there is *nothing that uses env* after this, we can leave '(env) as argument and preserving will discard it!
            '(env)
            (compile operand arg-reg 'next comp-env)
            ; this is a bit of a trick, we know eventually we want to use the argument registries in the operation.
            ; combining the sequence with a fake empty sequence that "needs" the registries to get the relevant save/restore instructions.
            ; see https://eli.thegreenplace.net/2008/04/18/sicp-section-55 for a different approach
            (preserving
              to-preserve
              (spread-arguments-2 (cdr operands) (cdr remaining-argument-regs) (cons arg-reg used-argument-regs))
              (make-instruction-sequence argument-registers '() '())
              )
            )
          )
        )
      )
    )
  )



; b.

; assume all operations use two arguments
(define (compile-primitive-op exp target linkage comp-env)
  (let ((op-name (operator exp))
         (operands (operands exp)))
    (let ((operands-codes (spread-arguments operands comp-env)))
      (end-with-linkage
        linkage
        (append-instruction-sequences
          operands-codes
          (make-instruction-sequence
            argument-registers
            (list target)
            `(
               (assign ,target (op ,op-name) (reg ,(car argument-registers)) (reg ,(cadr argument-registers)))
               )
            )
          )
        )
      )
    )
  )

; c. See other file
; d.
; > Extend your code generators for + and * so that they can handle expressions with arbitrary number of operands.
; > An expression with more than two operands will have to be compiled into a sequence of operations, each with only two inputs.

; I had a hard time coming up with this code!
(define (compile-primitive-op-bis exp target linkage comp-env)

  (let ((op-name (operator exp))
         (operands (operands exp)))
    (end-with-linkage
      linkage
      (preserving '(env)
        ; first step, then all the other steps are similar.
        (compile (car operands) 'arg1 'next comp-env)
        (next-steps (cdr operands) op-name target comp-env)
        )
      )
    )
  )

(define (next-steps remaining-operands op-name final-target comp-env)
  (cond ((null? remaining-operands) (empty-instruction-sequence))
    (else
      (let ((target (if (null? (cdr remaining-operands)) final-target 'arg1)))
        (preserving '(env)
          (preserving
            '(arg1)
            (compile (car remaining-operands) 'arg2 'next comp-env)
            (make-instruction-sequence argument-registers (list target) `((assign ,target (op ,op-name) (reg arg1) (reg arg2))))
            )
          (next-steps (cdr remaining-operands) op-name final-target comp-env)
          )
        )
      )
    )
  )
