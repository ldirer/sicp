; The compiler produces right to left evaluation of operands
; construct-arglist is responsible for that.

; The code evaluating from left to right will be **less efficient** than the one evaluating right to left.
; Because the right-to-left version reverses the list at compile time, while the left-to-right one has to use adjoin-arg (costlier than cons)


;; at the end of the day I didn't change much. using adjoin-arg instead of cons.
(define (construct-arglist operand-codes)
  (if (null? operand-codes)
    (make-instruction-sequence '() '(argl) '((assign argl (const ()))))
    (let ((code-to-get-first-arg
            (append-instruction-sequences
              (car operand-codes)
              (make-instruction-sequence '(val) '(argl) '((assign argl (op list) (reg val))))
              )))
      (if (null? (cdr operand-codes))
        code-to-get-first-arg
        (preserving '(env)
          code-to-get-first-arg
          (code-to-get-rest-args (cdr operand-codes))
          )
        )
      )
    )
  )

(define (code-to-get-rest-args operand-codes)
  (let ((code-for-next-arg
          (preserving
            '(argl)
            (car operand-codes)
            (make-instruction-sequence '(val argl) '(argl) '((assign argl (op adjoin-arg) (reg val) (reg argl))))
            )
          )
         )
    (if (null? (cdr operand-codes))
      code-for-next-arg
      (preserving '(env) code-for-next-arg (code-to-get-rest-args (cdr operand-codes)))
      )
    )
  )
