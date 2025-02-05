(load "ch4/syntax.scm")
(load "ch5/compiler/instruction_sequence.scm")
(load "ch5/compiler/ex5.38.scm")

; ex5.38
(define (open-coded-primitive? exp)
  (and (pair? exp) (memq (car exp) '(+ * = -)))
  )

(define (compile exp target linkage comp-env)
  (cond
    ((self-evaluating? exp) (compile-self-evaluating exp target linkage))
    ((quoted? exp) (compile-quoted exp target linkage))
    ((variable? exp) (compile-variable exp target linkage comp-env))
    ((assignment? exp) (compile-assignment exp target linkage comp-env))
    ((definition? exp) (compile-definition exp target linkage comp-env))
    ((if? exp) (compile-if exp target linkage comp-env))
    ((lambda? exp) (compile-lambda exp target linkage comp-env))
    ((begin? exp) (compile-sequence (begin-actions exp) target linkage comp-env))
    ((cond? exp) (compile (cond->if exp) target linkage comp-env))
;    ((open-coded-primitive? exp) (compile-primitive-op exp target linkage comp-env))
    ((open-coded-primitive? exp) (compile-primitive-op-bis exp target linkage comp-env))
    ((application? exp) (compile-application exp target linkage comp-env))
    (else (error "Unknown expression type -- COMPILE" exp))
    )
  )

(define (compile-linkage linkage)
  (cond
    ((eq? linkage 'return) (make-instruction-sequence
                             '(continue)
                             '()
                             '((goto (reg continue)))
                             ))
    ((eq? linkage 'next) (empty-instruction-sequence))
    (else (make-instruction-sequence '() '() `((goto (label ,linkage)))))
    )
  )


(define (end-with-linkage linkage instruction-sequence)
  ; I don't understand why preserving even needs a set of registers.
  ; Isn't it already part of the data on the instruction sequence?
  ; I would put in the 'automatic set' all registers needed by the second instruction sequence that are modified by the first instruction sequence.
  ; Here we are always preserving continue when we wouldn't have to? -> no, preserving takes the intersection of the 'automatic set' and that.
  ; ---> AAAAAH I think it's because sometimes we use a register BUT we expect it to have been changed!
  ;  ------> yes, look at compile-definition: if we preserve val we will have a bug, because we expect it to store the definition value (mentioned on p577 paper too)
  (preserving '(continue) instruction-sequence (compile-linkage linkage))
  )


(define all-regs '(env proc val argl continue))

(define label-counter 0)
(define (new-label-number)
  (set! label-counter (+ 1 label-counter))
  label-counter
  )

(define (make-label name)
  (string->symbol (string-append (symbol->string name) (number->string (new-label-number))))
  )


(define (make-compiled-procedure entry env)
  (list 'compiled-procedure entry env)
  )

(define (compiled-procedure? proc) (tagged-list? proc 'compiled-procedure))
(define (compiled-procedure-entry c-proc) (cadr c-proc))
(define (compiled-procedure-env c-proc) (caddr c-proc))





(define (compile-self-evaluating exp target linkage)
  (end-with-linkage linkage (make-instruction-sequence '() (list target) `((assign ,target (const ,exp)))))
  )

(define (compile-quoted exp target linkage)
  (end-with-linkage linkage (make-instruction-sequence '() (list target) `((assign ,target (const ,(text-of-quotation exp))))))
  )

(define (compile-variable exp target linkage comp-env)
  (end-with-linkage linkage
    (make-instruction-sequence
      '(env)
      (list target)
      `(
         (assign ,target (op lookup-variable-value) (const ,exp) (reg env))
         )
      )
    )
  )


(define (compile-assignment exp target linkage comp-env)
  (let ((var (assignment-variable exp)))
    (let ((get-value-code (compile (assignment-value exp) 'val 'next comp-env)))
      (end-with-linkage linkage
        (preserving '(env)
          get-value-code
          (make-instruction-sequence '(env val) (list target)
            `(
               ; might need to change this because I adapted the operation to return a value (for error handling)
               ; though I guess it's fine to 'perform' an op that returns something. It just means we don't have error handling in _this_ case.
               (perform (op set-variable-value!) (const ,var) (reg val) (reg env))
               (assign ,target (const ok))
               )
            )
          )
        )
      )
    )
  )

(define (compile-definition exp target linkage comp-env)
  (let ((var (definition-variable exp))
         (get-value-code (compile (definition-value exp) 'val 'next comp-env))
         )

    (end-with-linkage linkage
      (preserving '(env)
        get-value-code
        (make-instruction-sequence '(env val) (list target)
          `(
             (perform (op define-variable!) (const ,var) (reg val) (reg env))
             (assign ,target (const ok))
             )
          )
        )

      )
    )
  )


(define (compile-if exp target linkage comp-env)
  (let ((t-branch (make-label 'true-branch))
         (f-branch (make-label 'false-branch))
         (after-if (make-label 'after-if))
         )
    (let ((consequent-linkage
            (if (eq? linkage 'next) after-if linkage)))
      (let ((p-code (compile (if-predicate exp) 'val 'next comp-env))
             ; linkage in c-code vs a-code is explained in text, p578 paper.
             ; I think we could also have put after-if in both cases and then add the instruction list from (compile '() target linkage) at the end (extra goto in some cases though).
             (c-code (compile (if-consequent exp) target consequent-linkage comp-env))
             (a-code (compile (if-alternative exp) target linkage comp-env))
             )
        (preserving '(env continue)
          p-code
          (append-instruction-sequences
            (make-instruction-sequence '(val) '()
              `(
                 (test (op false?) (reg val))
                 (branch (label ,f-branch))
                 )
              )
            (parallel-instruction-sequences
              (append-instruction-sequences t-branch c-code)
              (append-instruction-sequences f-branch a-code)
              )
            after-if
            )
          )
        )

      )
    )
  )

(define (compile-sequence seq target linkage comp-env)
  (if (last-expr? seq)
    (compile (first-expr seq) target linkage comp-env)
    (preserving '(env continue)
      (compile (first-expr seq) target 'next comp-env)
      (compile-sequence (rest-exprs seq) target linkage comp-env)
      )
    )
  )



(define (compile-lambda exp target linkage comp-env)
  (let ((proc-entry (make-label 'entry))
         (after-lambda (make-label 'after-lambda)))
    (let ((lambda-linkage (if (eq? linkage 'next) after-lambda linkage)))
      (append-instruction-sequences
        (tack-on-instruction-sequence
          (end-with-linkage lambda-linkage
            (make-instruction-sequence '(env) (list target)
              `(
                 (assign ,target (op make-compiled-procedure) (label ,proc-entry) (reg env))
                 )
              ))
          (compile-lambda-body exp proc-entry comp-env))
        after-lambda
        )
      )
    )
  )


(define (compile-lambda-body exp proc-entry comp-env)
  (let ((formals (lambda-parameters exp)))
    (append-instruction-sequences
      (make-instruction-sequence '(env proc argl) '(env)
        `(
           ,proc-entry
           ; does this not make the assumption that the procedure object is in proc? We put it in 'target in compile-lambda...
           ; --> we put the lambda object in val, as a variable. Before application, the procedure object will be moved to 'proc.
           (assign env (op compiled-procedure-env) (reg proc))
           (assign env (op extend-environment) (const ,formals) (reg argl) (reg env))
           )
        )
      (compile-sequence (lambda-body exp) 'val 'return comp-env)
      )
    )
  )

;; structure:
;; compile operator, target proc, linkage next
;; evaluate operands, assign them to argl
;; compile procedure call with target, linkage
(define (compile-application exp target linkage comp-env)
  (let ((proc-code (compile (operator exp) 'proc 'next comp-env))
         (operand-codes (map (lambda (operand) (compile operand 'val 'next comp-env))
                          (operands exp))))
    (preserving '(env continue)
      proc-code
      (preserving '(proc continue)
        (construct-arglist operand-codes)
        (compile-procedure-call target linkage comp-env)
        )
      )
    )
  )


;(check-equal "empty operands list" (construct-arglist '()) '(assign argl (const ())))
(define (construct-arglist operand-codes)
  (let ((operand-codes (reverse operand-codes)))
    (if (null? operand-codes)
      (make-instruction-sequence '() '(argl) '((assign argl (const ()))))
      (let ((code-to-get-last-arg
              (append-instruction-sequences
                (car operand-codes)
                (make-instruction-sequence '(val) '(argl) '((assign argl (op list) (reg val))))
                )))
        (if (null? (cdr operand-codes))
          code-to-get-last-arg                ; termination
          (preserving '(env)                  ; recursion
            code-to-get-last-arg
            (code-to-get-rest-args (cdr operand-codes))
            )
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
            (make-instruction-sequence '(val argl) '(argl) '((assign argl (op cons) (reg val) (reg argl))))
            )
          )
         )
    (if (null? (cdr operand-codes))
      code-for-next-arg
      (preserving '(env) code-for-next-arg (code-to-get-rest-args (cdr operand-codes)))
      )
    )
  )



(define (compile-procedure-call target linkage comp-env)
  (let ((primitive-branch (make-label 'primitive-branch))
         (compiled-branch (make-label 'compiled-branch))
         (after-call (make-label 'after-call)))
    (let ((compiled-linkage (if (eq? linkage 'next) after-call linkage)))
      (append-instruction-sequences
        (make-instruction-sequence '(proc) '()
          `(
             (test (op primitive-procedure?) (reg proc))
             (branch (label ,primitive-branch))
             )
          )
        (parallel-instruction-sequences
          (append-instruction-sequences compiled-branch (compile-proc-appl target compiled-linkage))
          (append-instruction-sequences
            primitive-branch
            (end-with-linkage linkage
              (make-instruction-sequence '(proc argl) (list target)
                `(
                   (assign ,target (op apply-primitive-procedure) (reg proc) (reg argl))
                   )
                )
              )
            )
          )
        after-call
        )
      )
    )
  )


(define (compile-proc-appl target linkage)
  (cond
    ((and (not (eq? target 'val)) (eq? linkage 'return)) (error "return linkage, target not val -- COMPILE" target))    ; moved error cond first compared to book
    ((and (eq? target 'val) (not (eq? linkage 'return)))
      (make-instruction-sequence '(proc) all-regs
        `(
           (assign continue (label ,linkage))
           (assign val (op compiled-procedure-entry) (reg proc))
           (goto (reg val))
           )
        )
      )
    ((and (not (eq? target 'val)) (not (eq? linkage 'return)))
      (let ((proc-return (make-label 'proc-return)))
        (make-instruction-sequence '(proc) all-regs
          `(
             (assign continue (label ,proc-return))
             (assign val (op compiled-procedure-entry) (reg proc))
             (goto (reg val))
             ,proc-return
             (assign ,target (reg val))
             (goto (label ,linkage))
             )
          )
        )
      )
    ((and (eq? target 'val) (eq? linkage 'return))
      ; tail recursion happens here. Inside the compile procedure entry we will (goto (reg continue)) instead of [having saved continue first and] jumping to proc-return to restore and goto continue.
      (make-instruction-sequence '(proc continue) all-regs
        '(
           (assign val (op compiled-procedure-entry) (reg proc))
           (goto (reg val))
           )
        )
      )
    )
  )
