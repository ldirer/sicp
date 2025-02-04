; > spread-arguments should take an operand list and compile the given operands targeted to successive argument registers.
; argument registers: val, arg1, arg2
; > the primitive arithmetic operations will take their inputs from arg1 and arg2. The results may be put in val, arg1, ar2.


(define argument-registers '(arg1 arg2))
(define (spread-arguments operands)
  (spread-arguments-2 operands argument-registers (list))
  )

(define (spread-arguments-2 operands remaining-argument-regs used-argument-regs)
  (cond
    ((null? operands) (empty-instruction-sequence))
    ((and (null? remaining-argument-regs) (not (null? operands)))
      (error "not enough argument registers, remaining operands -- COMPILE" operands))
    (else
      (let ((operand (car operands)) (arg-reg (car remaining-argument-regs)))
        ; preserve argument registers because evaluating the operand might involve them
        ; skip preserving env for the last argument
        ; Look at tests (or think about (+ 1 (+ 2 3)) if it's not clear what should be preserved.
        (let ((to-preserve (if (null? (cdr operands)) (cons 'env (cons arg-reg used-argument-regs)) (cons arg-reg used-argument-regs))))
          (append-instruction-sequences
            (compile operand arg-reg 'next)
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
(define (compile-primitive-op exp target linkage)
  (let ((op-name (operator exp))
         (operands (operands exp)))
    (let ((operands-codes (spread-arguments operands)))
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