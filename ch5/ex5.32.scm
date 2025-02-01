; section 5.4 - The Explicit Control Evaluator
; Reminder: we assume a lot of primitive operations are available for simplicity.
; Really we would need to replace them with series of elementary instructions.


; b.
; > Alyssa P. Hacker suggests that by extending the evaluator to recognize more and more special cases we could incorporate all
; > the compiler's optimizations, and that this would eliminate the advantages of compilation altogether.
; I think:
; 1. We won't be able to reproduce the gains of the 'analyze' phase (similar to the analyzing interpreter).
; The interpreter will need to re-parse the body of a procedure every time it runs, the compiler can do better.
; 2. The evaluator tests to choose the optimized branch are at runtime, they are not free (unlike the compiler's).
; 3. It's hard to write this controller code! I expect the compiler code to be much easier to work with when it comes to optimizations.
; 4. Ultimately the compiler might be able to produce code that runs on a machine with different registers.
; In that sense it's not comparable to an optimized explicit control evaluator, that will always need the `exp` register.


(define dispatch-controller
  '(eval-dispatch
     (test (op self-evaluating?) (reg exp))
     (branch (label ev-self-eval))
     (test (op variable?) (reg exp))
     (branch (label ev-variable))
     (test (op quoted?) (reg exp))
     (branch (label ev-quoted))
     (test (op assignment?) (reg exp))
     (branch (label ev-assignment))
     (test (op definition?) (reg exp))
     (branch (label ev-definition))
     (test (op if?) (reg exp))
     (branch (label ev-if))
     (test (op cond?) (reg exp))
     (branch (label ev-cond))
     (test (op let?) (reg exp))
     (branch (label ev-let))
     (test (op lambda?) (reg exp))
     (branch (label ev-lambda))
     (test (op begin?) (reg exp))
     (branch (label ev-begin))
     (test (op application?) (reg exp))
     (branch (label ev-application))
     (goto (label unknown-expression-type))
     )
  )


; I thought about skipping the 'application' controller code and just interpreting `internal-eval exp env` directly.
; But it meant adding a test at the top level of the dispatch. Which I thought was not very nice. Feels wasteful...
; Though obviously *here* it does not matter.
; So eventually I settled for a special 'internal-eval keyword/reserved variable.
(define internal-eval-controller
  '(
     internal-eval
     (save exp)
     (save env)
     (save continue)
     (assign exp (op first-operand) (reg argl))
     (assign argl (op rest-operands) (reg argl))
     (assign env (op first-operand) (reg argl))
     (assign continue (label after-eval))
     (goto (label eval-dispatch))

     after-eval
     (restore continue)
     (restore env)
     (restore exp)
     (goto (reg continue))
     )
  )

(define self-ev-controller
  '(
     ev-self-eval
     (assign val (reg exp))
     (goto (reg continue))
     ev-variable
     ; this is hardcoded and admittedly pretty terrible, but I'm not sure how to do it differently!
     ; we need a keyword or a special variable to bridge the scheme code - controller code gap. Missing something?..
     ; thinking about it, we could use a tagged list. Primitives do that. Leaving it at that.
     (test (op equal?) (reg exp) (const internal-eval))
     (branch (label ev-variable-internal))
     (assign val (op lookup-variable-value) (reg exp) (reg env))
     ; ex5.30 - handle unbound variable error
     (test (op unbound-variable-error?) (reg val))
     (branch (label unbound-variable))
     (goto (reg continue))

     unbound-variable
     (assign val (const unbound-variable-error))
     (assign val (op cons) (reg val) (reg exp))
     (goto (label signal-error))

     ev-variable-internal
     ; use a type tag to identify the value as a controller procedure later on
     (assign val (label internal-eval))
     (assign val (op cons) (const controller-procedure) (reg val))
     (goto (reg continue))

     ev-quoted
     (assign val (op text-of-quotation) (reg exp))
     (goto (reg continue))
     ev-lambda
     (assign unev (op lambda-parameters) (reg exp))
     (assign exp (op lambda-body) (reg exp))
     (assign val (op make-procedure) (reg unev) (reg exp) (reg env))
     (goto (reg continue))
     ))


(define ev-application-controller
  '(
     ev-application
     (save continue)
     (assign unev (op operands) (reg exp))
     (assign exp (op operator) (reg exp))

     ; optimization: don't save/restore env if the operator is a symbol (evaluating it does not modify env). Also unev.
     (test (op variable?) (reg exp))
     (branch (label ev-appl-operator-symbol))
     (save env)
     (save unev)
     (assign continue (label ev-appl-did-operator-restore))
     (goto (label eval-dispatch))

     ev-appl-operator-symbol
     (assign continue (label ev-appl-did-operator-no-restore))
     (goto (label eval-dispatch))

     ev-appl-did-operator-restore
     (restore unev)                                    ; the operands
     (restore env)

     ev-appl-did-operator-no-restore
     (assign argl (op empty-arglist))
     (assign proc (reg val))                           ; the operator
     (test (op no-operands?) (reg unev))
     (branch (label apply-dispatch))
     (save proc)

     ev-appl-operand-loop
     (save argl)
     (assign exp (op first-operand) (reg unev))
     (test (op last-operand?) (reg unev))
     (branch (label ev-appl-last-arg))                 ; this is an optimization - no need to save the environment or unevaluated operands for the last argument
     (save env)
     (save unev)
     (assign continue (label ev-appl-accumulate-arg))
     (goto (label eval-dispatch))

     ev-appl-accumulate-arg
     (restore unev)
     (restore env)
     (restore argl)
     (assign argl (op adjoin-arg) (reg val) (reg argl))
     (assign unev (op rest-operands) (reg unev))
     (goto (label ev-appl-operand-loop))


     ev-appl-last-arg
     (assign continue (label ev-appl-accum-last-arg))
     (goto (label eval-dispatch))

     ev-appl-accum-last-arg
     (restore argl)
     (assign argl (op adjoin-arg) (reg val) (reg argl))
     (restore proc)
     (goto (label apply-dispatch))
     )
  )


; expects the 'continue' address on the stack.
(define apply-controller
  '(
     apply-dispatch
     (test (op primitive-procedure?) (reg proc))
     (branch (label primitive-apply))
     (test (op compound-procedure?) (reg proc))
     (branch (label compound-apply))
     (test (op controller-procedure?) (reg proc))
     (branch (label controller-defined-apply))
     (goto (label unknown-procedure-type))

     controller-defined-apply
     ; proc stores an object with the controller label to jump to.
     (assign continue (label after-controller-defined-apply))
     (assign proc (op controller-procedure-label) (reg proc))
     (goto (reg proc))

     after-controller-defined-apply
     (restore continue)
     (goto (reg continue))

     primitive-apply
     (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
     (restore continue)
     (goto (reg continue))


     compound-apply
     (assign unev (op procedure-parameters) (reg proc))
     (assign env (op procedure-environment) (reg proc))
     (assign env (op extend-environment) (reg unev) (reg argl) (reg env))

     (test (op too-many-arguments-error?) (reg env))
     (branch (label too-many-arguments-error))
     (test (op too-few-arguments-error?) (reg env))
     (branch (label too-few-arguments-error))

     (assign unev (op procedure-body) (reg proc))
     (goto (label ev-sequence))

     too-many-arguments-error
     (assign val (const too-many-arguments-error))
     (goto (label signal-error))

     too-few-arguments-error
     (assign val (const too-few-arguments-error))
     (goto (label signal-error))

     ev-begin
     (assign unev (op begin-actions) (reg exp))
     (save continue)
     (goto (label ev-sequence))
     )
  )

;; note that this expects continue to be *on the stack*, and unev to contain the sequence of expressions.
;; I had missed that fact early on (although it is clearly mentioned in the book as something important :)), it's crucial to be able to use this correctly.
(define ev-sequence-controller
  '(
     ev-sequence
     (assign exp (op first-exp) (reg unev))
     (test (op last-exp?) (reg unev))
     (branch (label ev-sequence-last-exp))
     (save unev)
     (save env)
     (assign continue (label ev-sequence-continue))
     (goto (label eval-dispatch))

     ev-sequence-continue
     (restore env)
     (restore unev)
     (assign unev (op rest-exps) (reg unev))
     (goto (label ev-sequence))

     ev-sequence-last-exp                                          ; this way of treating the last expression separately is what makes tail recursion. See p557 paper.
     (restore continue)
     (goto (label eval-dispatch))
     )
  )

;;; this version treats the last expression in a sequence like the others
;;; seems like a minor change, but breaks tail recursion!
;;; Because we save unev and env before evaluating the last expression, we will only pop them from the stack once this is done.
;;; Thus the stack will grow with each recursive call.
;;; But we don't need to save these registers! This is what the tail recursive version uses.
(define ev-sequence-controller-not-tail-recursive
  '(
     ev-sequence
     (test (op no-more-exps?) (reg unev))
     (branch (label ev-sequence-end))
     (assign exp (op first-exp) (reg unev))
     (save unev)
     (save env)
     (assign continue (label ev-sequence-continue))
     (goto (label eval-dispatch))
     ev-sequence-continue
     (restore env)
     (restore unev)
     (assign unev (op rest-exps) (reg unev))
     (goto (label ev-sequence))
     ev-sequence-end
     (restore continue)
     (goto (reg continue))
     )
  )


(define conditional-controller
  '(
     ev-if
     (save exp)                                                    ; save expression for later
     (save env)
     (save continue)
     (assign continue (label ev-if-decide))
     (assign exp (op if-predicate) (reg exp))
     (goto (label eval-dispatch))                                  ; evaluate the predicate

     ev-if-decide
     (restore continue)
     (restore env)
     (restore exp)
     (test (op true?) (reg val))
     (branch (label ev-if-consequent))

     ev-if-alternative
     (assign exp (op if-alternative) (reg exp))
     (goto (label eval-dispatch))
     ev-if-consequent
     (assign exp (op if-consequent) (reg exp))
     (goto (label eval-dispatch))
     )
  )



(define assignment-controller
  '(
     ev-assignment
     (assign unev (op assignment-variable) (reg exp))
     (save unev)                                                   ; save variable for later
     (assign exp (op assignment-value) (reg exp))
     (save env)
     (save continue)
     (assign continue (label ev-assignment-1))
     (goto (label eval-dispatch))                                  ; evaluate the assignment value
     ev-assignment-1                                               ; could have been named 'ev-assignment-after-value'
     (restore continue)
     (restore env)
     (restore unev)
     (assign val (op set-variable-value!) (reg unev) (reg val) (reg env))
     (test (op unbound-variable-error?) (reg val))
     (branch (label assignment-unbound-variable))
     (goto (reg continue))

     assignment-unbound-variable
     (assign val (const unbound-variable-error))
     (assign val (op cons) (reg val) (reg unev))
     (goto (label signal-error))
     )
  )

(define definition-controller
  '(
     ev-definition
     (assign unev (op definition-variable) (reg exp))
     (save unev)                                                    ; save variable for later
     (assign exp (op definition-value) (reg exp))
     (save env)
     (save continue)
     (assign continue (label ev-definition-1))
     (goto (label eval-dispatch))                                   ; evaluate the definition value

     ev-definition-1
     (restore continue)
     (restore env)
     (restore unev)
     (perform (op define-variable!) (reg unev) (reg val) (reg env))
     (assign val (const ok))
     (goto (reg continue))
     )
  )



(define evaluator-controller
  (append
    dispatch-controller
    self-ev-controller
    ev-application-controller
    apply-controller
    ev-sequence-controller
    conditional-controller
    assignment-controller
    definition-controller
    internal-eval-controller
    )
  )

