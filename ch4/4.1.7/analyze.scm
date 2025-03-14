(load "ch4/syntax.scm")
(load "ch4/environment.scm")
(load "ch4/interpreter_rules.scm")
(load "ch4/4.1.7/ex4.22.scm")

(define (analyze exp)
  (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
    ((quoted? exp) (analyze-quoted exp))
    ((variable? exp) (analyze-variable exp))
    ((assignment? exp) (analyze-assignment exp))
    ((definition? exp) (analyze-definition exp))
    ((if? exp) (analyze-if exp))
    ((let? exp) (analyze-let exp))
    ((lambda? exp) (analyze-lambda exp))
    ((begin? exp) (analyze-sequence (begin-actions exp)))
    ((cond? exp) (analyze (cond->if exp)))
    ((application? exp) (analyze-application exp))
    (else (error "Unknown expression type: ANALYZE" exp)))
  )


(define (analyze-self-evaluating exp)
  (lambda (env) exp))


(define (analyze-quoted exp)
  (let ((qval (text-of-quotation exp)))
    (lambda (env) qval))
  )


(define (analyze-variable exp)
  (lambda (env) (lookup-variable-value exp env))
  )


(define (analyze-assignment exp)
  ; variable part does not need to be analyzed, it's just a name.
  ; I guess we could analyze it further though, maybe in section 5.something? I'm thinking about when we record
  ; the position in the env stack a variable should refer to.
  (let ((var (assignment-variable expr))
         (val (analyze (assignment-value expr)))
         )
    (lambda (env) (
                    (set-variable-value!
                      var
                      (val env)
                      env
                      )
                    'ok
                    ))
    )
  )

(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
         (cproc (analyze (if-consequent exp)))
         (aproc (analyze (if-alternative exp))))
    (lambda (env) (if (true? (pproc env))
                    (cproc env)
                    (aproc env)))))


(define (analyze-lambda exp)
  (let ((vars (lambda-parameters exp))
         (bproc (analyze-sequence (lambda-body exp))))
    (lambda (env) (make-procedure vars bproc env))))


(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env) (proc1 env) (proc2 env)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
      first-proc
      (loop (sequentially first-proc (car rest-procs))
        (cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs) (error "Empty sequence: ANALYZE"))
    (loop (car procs) (cdr procs))))


(define (analyze-application exp)
  (let ((fproc (analyze (operator exp)))
         (aprocs (map analyze (operands exp))))
    (lambda (env)
      (execute-application
        (fproc env)
        (map (lambda (aproc) (aproc env))
          aprocs)))))

(define (execute-application proc args)
  (cond
    ((primitive-procedure? proc)
      (apply-primitive-procedure proc args))
    ((compound-procedure? proc)
      ((procedure-body proc)
        (extend-environment
          (procedure-parameters proc)
          args
          (procedure-environment proc))))
    (else
      (error "Unknown procedure type: EXECUTE-APPLICATION"
        proc))))


(define (analyze-definition exp)
  (let ((var (definition-variable exp))
         (vproc (analyze (definition-value exp))))
    (lambda (env)
      (define-variable! var (vproc env) env)
      'ok
      )
    )
  )