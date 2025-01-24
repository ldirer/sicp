(load "ch4/syntax.scm")
(load "ch4/4.1.4/driver.scm")
(load "ch4/environment.scm")
(load "ch4/4.1.4/primitives.scm")
(load "ch4/interpreter_rules.scm")

(define (empty-arglist) (list))
(define (adjoin-arg arg arglist) (append arglist (list arg)))
(define (last-operand? ops) (null? (cdr ops)))


(define the-global-environment (setup-environment))
(define (get-global-environment) the-global-environment)

(define (true? x) (not (eq? x false)))
(define (false? x) (eq? x false))


(define (cond-clauses-first clauses) (car clauses))
(define (cond-clauses-rest clauses) (cdr clauses))
(define (no-cond-clauses? clauses) (null? clauses))

(define (debug-print . args)
  (newline)
  (for-each (lambda (arg)
              (display arg)
              (display " ")
              )
    args)
  )

(define eceval-operations
  (list
    (list 'debug-print debug-print)
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
    )
  )