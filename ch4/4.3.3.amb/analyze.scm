(load "ch4/interpreter_preload.scm")
(load "ch4/syntax.scm")
(load "ch4/environment.scm")
(load "ch4/interpreter_rules.scm")
(load "ch4/4.1.7/ex4.22.scm")


(define (amb? exp) (tagged-list? exp 'amb))
(define (amb-choices exp) (cdr exp))

(define (analyze-amb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices)
        (if (null? choices)
          (fail)
          ((car choices)
            env
            succeed
            (lambda ()
              (try-next (cdr choices))
              )
            )
          )
        )
      (try-next cprocs)
      )
    )
  )


(define (analyze exp)
  (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
    ((amb? exp) (analyze-amb exp))
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
  (lambda (env succeed fail) (succeed exp fail))
  )


(define (analyze-quoted exp)
  (let ((qval (text-of-quotation exp)))
    (lambda (env succeed fail) (succeed qval fail))
    )
  )


(define (analyze-variable exp)
  (lambda (env succeed fail) (succeed (lookup-variable-value exp env) fail)
    )
  )


(define (analyze-assignment exp)
  (let ((var (assignment-variable expr))
         (val (analyze (assignment-value expr)))
         )
    (lambda (env succeed fail)
      (val env
        (lambda (new-value fail2)
          (let ((old-value (lookup-variable-value var env)))
            (set-variable-value!
              var
              new-value
              env
              )
            ; if there's a failure later on, set the value back to the saved one
            (succeed 'ok (lambda () ((set-variable-value! var old-value env) (fail2))))
            )
          )
        fail
        )
      )
    )
  )


(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
         (cproc (analyze (if-consequent exp)))
         (aproc (analyze (if-alternative exp)))
         (condition-succeed (lambda (value fail) value))
         )

    (lambda (env succeed fail)
      (
        (pproc env
          ; success continuation - on succesful predicate value computation
          (lambda (pred-value fail2)
            (if (true? pred-value)
              (cproc env succeed fail2)
              (aproc env succeed fail2)
              )
            )
          fail
          )
        )
      )
    )
  )


(define (analyze-lambda exp)
  (let ((vars (lambda-parameters exp))
         (bproc (analyze-sequence (lambda-body exp))))
    (lambda (env succeed fail) (succeed (make-procedure vars bproc env) fail)))
  )


; calling a then b means calling a with a continuation that calls b on success
; damn! we only need to modify the 'sequentially' procedure. How nice.
(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env succeed fail)
      ; in the regular analyzer we called proc1 and proc2 in sequence, here we use the continuation procedures
      (proc1 env
        (lambda (proc1-value fail2)
          (proc2 env succeed fail2)
          )
        fail
        )
      )
    )
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
    (lambda (env succeed fail)
      (fproc env
        (lambda (proc fail2)
          (get-args
            aprocs
            env
            (lambda (args fail3) (execute-application proc args succeed fail3))
            fail2)
          )
        fail
        )
      )
    )
  )

(define (get-args aprocs env succeed fail)
  (cond
    ((null? aprocs) (succeed '() fail))
    (else ((car aprocs)
            env
            (lambda (arg fail2)
              (get-args
                (cdr aprocs)
                env
                ; continuation for get-args
                (lambda (args fail3)
                  (succeed (cons arg args) fail3)
                  )
                fail2)
              )
            fail
            )
      )
    )
  )

(define (execute-application proc args succeed fail)
  (cond
    ((primitive-procedure? proc) (succeed (apply-primitive-procedure proc args) fail))
    ((compound-procedure? proc)
      ((procedure-body proc)
        (extend-environment
          (procedure-parameters proc)
          args
          (procedure-environment proc)
          )
        ; initially I wrote:
        ; (lambda (returned-value fail2)
        ;  (succeed returned-value fail2)
        ; ) ; then I saw the book just had 'succeed'. yeah.
        succeed
        fail
        )
      )
    (else
      (error "Unknown procedure type: EXECUTE-APPLICATION"
        proc))
    )
  )


(define (analyze-definition exp)
  (let ((var (definition-variable exp))
         (vproc (analyze (definition-value exp))))
    (lambda (env succeed fail)
      (vproc env
        (lambda (value fail2)
          (define-variable! var value env)
          (succeed 'ok fail2)
          )
        fail
        )
      )
    )
  )
