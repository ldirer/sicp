; > spread-arguments should take an operand list and compile the given operands targeted to successive argument registers.
; argument registers: val, arg1, arg2
; > the primitive arithmetic operations will take their inputs from arg1 and arg2. The results may be put in val, arg1, ar2.


; This one was harder than I initially thought
; For spread-arguments, I was tempted at some point to use an approach similar to the one at https://www.inchmeal.io/sicp/ch-5/ex-5.38.html
; Specifically the part with:
;		   (preserving (cdr arg-regs)
;					   first-seq
;					   (make-instruction-sequence (cdr arg-regs) '() '()))))))
; It's a trick to force save/restore of relevant argument registries (here cdr because of the order the author decided the operands should be evaluated in)
; But ultimately I think it's not the best solution, it will force save/restore even when not necessary.
; --> noooo it won't :))

(define argument-registers '(arg1 arg2))
(define (spread-arguments operands)
  (spread-arguments-2 operands argument-registers)
  ;  (cond
  ;    ((null? operands) (empty-instruction-sequence))
  ;    (else
  ;      (car operands)
  ;      (car argument-registers)
  ;      (preserving argument-registers
  ;        (compile (car operands) (list (car argument-registers)) 'next)
  ;        (spread-arguments-2 (cdr operands) (cdr argument-registers))
  ;        )
  ;      )
  ;    )
  )

(define (spread-arguments-2 operands argument-regs)
  (cond
;    ((null? operands) (empty-instruction-sequence))    ; TODO remove if we do end up returning a plain list
    ((null? operands) '())
    ((and (null? argument-regs) (not (null? operands)))
      (error "not enough argument registers, remaining operands -- COMPILE" operands))
    (else
      (let ((operand (car operands)) (arg-reg (car argument-regs)))
        ; preserve argument registers because evaluating the operand might involve them
        ; skip preserving env for the last argument
        (let ((to-preserve (if (null? (cdr operands)) (cons 'env argument-registers) argument-registers)))
          ;          TODO real logic flaw apparently? the result doesn't say it needs the correct registers
          ;          (newline)
          ;          (display "(compile operand arg-reg 'next)")
          ;          (newline)
          ;          (display (compile operand arg-reg 'next))
          ;          (newline)
          ;          (display "to-preserve ")
          ;          (display to-preserve)
          (cons
            (compile operand arg-reg 'next)
            (spread-arguments-2 (cdr operands) (cdr argument-regs))
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
;      (newline)
;      (display "operands-codes ")
;      (display operands-codes)
      (end-with-linkage
        linkage
        ; TODO something here... I used append-instruction-sequences. it looks at the two sequences and sees the second one "needs" registers "modified" by the first one.
        ; the combined sequence does not "need" them.
        ; But I think this should be fine!!...
        (append-instruction-sequences
          (car operands-codes)
          (preserving '(arg1)
            (cadr operands-codes)
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
  )