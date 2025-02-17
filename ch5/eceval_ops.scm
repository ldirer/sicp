(load "ch4/syntax.scm")
(load "ch4/4.1.4/driver.scm")
(load "ch4/environment.scm")
(load "ch5/primitives.scm")
(load "ch4/interpreter_rules.scm")
(load "ch5/lazy.scm")
(load "ch5/ex5.30_a.scm")
; compiled-procedure? and co
(load "ch5/compiler/compiler.scm")
(load "ch5/compiler/ex5.39_lexical_addressing.scm")

(define (empty-arglist) (list))
(define (adjoin-arg arg arglist) (append arglist (list arg)))
(define (last-operand? ops) (null? (cdr ops)))

(define the-global-environment (setup-environment))
(define eval (make-procedure '(exp env) '((internal-eval exp env)) the-global-environment))
;; make the env object available inside the eceval. If we wanted a procedure we'd need to call make-procedure.
(define-variable! 'the-global-environment the-global-environment the-global-environment)
(define-variable! 'eval eval the-global-environment)

(define (get-global-environment) the-global-environment)

(define (true? x) (not (eq? x false)))
(define (false? x) (eq? x false))


(define (cond-clauses-first clauses) (car clauses))
(define (cond-clauses-rest clauses) (cdr clauses))
(define (no-cond-clauses? clauses) (null? clauses))

(define (debug-print . args)
  (newline)
  (for-each (lambda (arg)
              (user-print arg)
              (display " ")
              )
    args)
  )


(define (controller-procedure? obj) (eq? (car obj) 'controller-procedure))
(define (controller-procedure-label obj) (cdr obj))

(define eceval-operations
  (list
    ; ex5.46 - adding < as open-coded primitive
    (list '< <)
    ; lexical addressing
    (list 'lexical-address-lookup lexical-address-lookup)
    (list 'lexical-address-set! lexical-address-set!)
    ; section 5.5.7
    (list 'make-compiled-procedure make-compiled-procedure)
    (list 'compiled-procedure-env compiled-procedure-env)
    (list 'compiled-procedure? compiled-procedure?)
    (list 'compiled-procedure-entry compiled-procedure-entry)
    (list 'list list)
    (list 'false? false?)
    (list '= =)
    (list '+ +)
    (list '- -)
    (list '* *)

    ; ex5.30
    (list 'unbound-variable-error? unbound-variable-error?)
    (list 'too-many-arguments-error? too-many-arguments-error?)
    (list 'too-few-arguments-error? too-few-arguments-error?)

    ; side quest, see eceval_test_eval.scm
    (list 'controller-procedure? controller-procedure?)
    (list 'controller-procedure-label controller-procedure-label)

    ; ex5.25 - normal order evaluation
    (list 'set-car! set-car!)
    (list 'set-cdr! set-cdr!)
    (list 'car car)
    (list 'cdr cdr)
    (list 'cons cons)
    (list 'delay-it delay-it)
    (list 'thunk? thunk?)
    (list 'thunk-exp thunk-expr)  ; exp vs expr renaming
    (list 'thunk-env thunk-env)
    (list 'evaluated-thunk? evaluated-thunk?)
    (list 'evaluated-thunk-value evaluated-thunk-value)

    (list 'list-of-values-delayed list-of-values-delayed)

    ; ex5.23
    (list 'cond? cond?)
    (list 'cond->if cond->if)
    (list 'let? let?)
    (list 'let->combination let->combination)
    ; ex5.24
    (list 'cond-clauses cond-clauses)
    (list 'cond-clauses-first cond-clauses-first)
    (list 'cond-clauses-rest cond-clauses-rest)
    (list 'no-cond-clauses? no-cond-clauses?)
    (list 'cond-else-clause? cond-else-clause?)
    (list 'cond-predicate cond-predicate)
    (list 'cond-actions cond-actions)


    (list 'self-evaluating? self-evaluating?)
    (list 'variable? variable?)
    (list 'quoted? quoted?)
    (list 'assignment? assignment?)
    (list 'definition? definition?)
    (list 'if? if?)
    (list 'lambda? lambda?)
    (list 'begin? begin?)
    (list 'application? application?)
    (list 'lookup-variable-value lookup-variable-value)
    (list 'text-of-quotation text-of-quotation)
    (list 'lambda-parameters lambda-parameters)
    (list 'lambda-body lambda-body)
    (list 'make-procedure make-procedure)
    (list 'operands operands)
    (list 'operator operator)
    (list 'empty-arglist empty-arglist)
    (list 'no-operands? no-operands?)
    (list 'first-operand first-operand)
    (list 'last-operand? last-operand?)
    (list 'adjoin-arg adjoin-arg)
    (list 'rest-operands rest-operands)
    (list 'primitive-procedure? primitive-procedure?)
    (list 'compound-procedure? compound-procedure?)
    (list 'apply-primitive-procedure apply-primitive-procedure)
    (list 'procedure-parameters procedure-parameters)
    (list 'procedure-environment procedure-environment)
    (list 'extend-environment extend-environment)
    (list 'procedure-body procedure-body)
    (list 'begin-actions begin-actions)
    ; I'd gone for my own naming with expr instead of exp for part of chapter 4. Using the book's convention now.
    (list 'first-exp first-expr)
    (list 'last-exp? last-expr?)
    (list 'rest-exps rest-exprs)
    (list 'if-predicate if-predicate)
    (list 'true? true?)
    (list 'if-alternative if-alternative)
    (list 'if-consequent if-consequent)
    (list 'assignment-variable assignment-variable)
    (list 'assignment-value assignment-value)
    (list 'set-variable-value! set-variable-value!)
    (list 'definition-variable definition-variable)
    (list 'definition-value definition-value)
    (list 'define-variable! define-variable!)
    ; builtin machine instruction
    ; (list 'initialize-stack initialize-stack)
    (list 'prompt-for-input prompt-for-input)
    (list 'read read)
    (list 'get-global-environment get-global-environment)
    (list 'announce-output announce-output)
    (list 'user-print user-print)
    ; debugging
    (list 'equal? equal?)
    (list 'debug-print debug-print)
    )
  )