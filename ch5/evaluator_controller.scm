; section 5.4 - The Explicit Control Evaluator
; Reminder: we assume a lot of primitive operations are available for simplicity.
; Really we would need to replace them with series of elementary instructions.
; TODO: DO IT TWO WAYS
; 1. FORCE AND OTHER STUFF AS CONTROLLER CODE. LIKE INCHMEAL.
; 2. ONCE THIS WORKS, AN ALTERNATIVE WITH EVAL. IT SHOULD BE POSSIBLE (and lets us move some controller code to primitives).
; -> I'm going to try 2 first.

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


; TODO: cleanup we need to compute the args before going to eval-dispatch.
; like a primitive function. Erm.
; ALSO: this is almost certainly not how we want to do things. This hardcodes `eval` as something that can't be overwritten.
; --> How do we bridge the gap between controller-defined functions and user code then??
; I think we need special syntax. But it could be behind an 'internal-' prefix.

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
     (test (op equal?) (reg exp) (const internal-eval))
     (branch (label ev-variable-internal))
     (assign val (op lookup-variable-value) (reg exp) (reg env))
     (goto (reg continue))

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
     (save env)
     (assign unev (op operands) (reg exp))
     (save unev)
     (assign exp (op operator) (reg exp))
     (assign continue (label ev-appl-did-operator))
     (goto (label eval-dispatch))


     ev-appl-did-operator
     (restore unev)                                    ; the operands
     (restore env)
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
     (assign unev (op procedure-body) (reg proc))
     (goto (label ev-sequence))

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
     (perform (op set-variable-value!) (reg unev) (reg val) (reg env))
     (assign val (const ok))
     (goto (reg continue))
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




