; In my opinion this implementation is much nicer: https://www.inchmeal.io/sicp/ch-5/ex-5.25.html
; A couple interesting things that make it nicer:
; - force-it uses the val register as input. Makes the code more optimized but also simpler to read.
; - The code reuses the ev-appl-operands-.. bit with minimal modifications (see other comment in code) instead of rewriting a complicated 'list-of-actual-values' like I did here.
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

; expects its argument as a single item in `argl`.
(define force-it-controller
  '(
     force-it
     (test (op thunk?) (reg argl))
     (branch (label force-thunk))
     (test (op evaluated-thunk?) (reg argl))
     (branch (label force-evaluated-thunk))
     ; else, regular object
;     (perform (op debug-print) (const "force it finishing with:") (reg argl))
     (assign val (reg argl))
     (goto (reg continue))

     force-evaluated-thunk
     (assign val (op evaluated-thunk-value) (reg argl))
     (goto (reg continue))

     force-thunk
     ; setup registers for actual value
     (save exp)
     (save env)
     (save argl)

     (assign exp (op thunk-exp) (reg argl))
     (assign env (op thunk-env) (reg argl))

     (save continue)
     (assign continue (label after-actual-value))
     (goto (label actual-value))

     after-actual-value
     (restore continue)
     (restore argl)
     (restore env)
     (restore exp)
     ; Building evaluated thunk object. result is in val, obj in argl (using p406 paper definition of force-it)
     ; This could have been done in an operation procedure.
     (perform (op set-car!) (reg argl) (const evaluated-thunk))
     (assign argl (op cdr) (reg argl))
     (perform (op set-car!) (reg argl) (reg val))
     (perform (op set-cdr!) (reg argl) (const ()))
     ; result already in val
     (goto (reg continue))

     ; expects exp and env in registers
     actual-value
     (save continue)
     (assign continue (label after-eval))
     (goto (label eval-dispatch))

     after-eval
     (restore continue)
     (assign argl (reg val))
     (goto (label force-it))
     )
  )

(define self-ev-controller
  '(
     ev-self-eval
     (assign val (reg exp))
     (goto (reg continue))
     ev-variable
     (assign val (op lookup-variable-value) (reg exp) (reg env))
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
;     (perform (op debug-print) (const "in ev application:") (reg exp))
     (assign exp (op operator) (reg exp))
     (assign continue (label ev-appl-did-operator))
     (goto (label actual-value))

     ev-appl-did-operator
     (restore unev)                                    ; the operands
;     (perform (op debug-print) (const "in ev appl did operator; val unev") (reg val) (reg unev))
     (restore env)
     (assign argl (reg unev))
     (assign proc (reg val))                           ; the operator

     (goto (label apply-dispatch))

     ; this block could have been replaced by an operation proc
     list-of-delayed-values
     (test (op no-operands?) (reg unev))
     (branch (label list-of-delayed-values-done))

     (assign exp (op first-operand) (reg unev))

     (assign val (op delay-it) (reg exp) (reg env))
     (assign argl (op adjoin-arg) (reg val) (reg argl))
     (assign unev (op rest-operands) (reg unev))
     (goto (label list-of-delayed-values))

     list-of-delayed-values-done
     (goto (reg continue))
     )
  )


(define apply-controller
  '(
     apply-dispatch
     (test (op primitive-procedure?) (reg proc))
     (branch (label primitive-apply))
     (test (op compound-procedure?) (reg proc))
     (branch (label compound-apply))
     (goto (label unknown-procedure-type))

     primitive-apply
     ; not saving because the relevant continue is already saved on the stack and the contract is that apply consumes it
     (assign continue (label after-list-of-arg-values))
     (save proc)
     (goto (label list-of-arg-values))

     after-list-of-arg-values
     (restore proc)
     (assign argl (reg val))              ; not *super* consistent with the other arg transform. the other one operates on argl directly. Whatever.
     (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;     (perform (op debug-print) (const "applied a primitive and got: ") (reg val))
     (restore continue)
     (goto (reg continue))


     compound-apply
     (save continue)
     (assign unev (reg argl))
     (assign argl (op empty-arglist))
     (assign continue (label operands-thunked))
     ; list-of-delayed-values accumulates its result in argl
     (goto (label list-of-delayed-values))

     operands-thunked
     (restore continue)
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

;; So I wrote this... But really this is a possibly buggy, more complicated version of the required change.
;; We could just take the original 'ev-appl-operands' bit and replace (goto (label eval-dispatch)) with (goto (label actual-value)). That's it :)
(define list-of-arg-values-controller
  '(
     ; I think I changed semantics of left-to-right vs right-to-left arg evaluation here by evaluating
     ; the recursive call before actual value? Oh well.
     ; not sure why it felt simpler to write like that, not seeing it anymore.

     ; expects exps in argl and env in env (as if it was not an argument, a bit different from the version at p403 paper.
     list-of-arg-values
     (test (op no-operands?) (reg argl))
     (branch (label list-of-arg-values-end))

     ; recursive call setup
     (save continue)
     ; prepare arguments for actual value on the stack
     (assign exp (op first-operand) (reg argl))
     (save exp)
     (save env)

     (assign argl (op rest-operands) (reg argl))
     (assign continue (label list-of-arg-values-after-rec))
     (goto (label list-of-arg-values))

     list-of-arg-values-after-rec
     (restore env)
     (restore exp)

     (save val)
     (assign continue (label list-of-arg-values-after-actual-value))
     (goto (label actual-value))

     list-of-arg-values-after-actual-value
     ; use unev as temp register to store actual value result
     (assign unev (reg val))
     (restore val)
     (restore continue)
     (assign val (op cons) (reg unev) (reg val))

     (goto (reg continue))

     list-of-arg-values-end
     (assign val (const ()))
     (goto (reg continue))
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
     (perform (op debug-print) (const "if predicate:") (reg exp))
     (goto (label actual-value))                                   ; evaluate the predicate

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
    force-it-controller
    list-of-arg-values-controller
    )
  )




