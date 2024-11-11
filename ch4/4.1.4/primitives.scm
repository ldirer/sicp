(load "ch4/environment.scm")
(define (setup-environment)
  (let ((initial-env
          (extend-environment (primitive-procedure-names)
            (primitive-procedure-objects)
            the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    (define-variable! 'nil (list) initial-env)
    initial-env
    ))

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive)
  )

(define (primitive-implementation proc) (cadr proc))

(define (get-primitive-procedures)
  (list
    (list 'car car)
    (list 'cdr cdr)
    (list 'cons cons)
    (list 'null? null?)
    ; added compared to the book
    ; apply is required to implement map?
    ; -> a bit confused by this, with imports `apply` might not be the builtin one but our custom function
    ; --> yes, we want the custom function here. As first argument we will pass it one of our 'procedure objects.
    ; The builtin apply cannot handle that.
    (list 'apply apply)
    (list '+ +)
    (list '* *)
    (list '- -)
    (list '/ /)
    (list '= =)
    (list '< <)
    (list '<= <=)
    (list '> >)
    (list '>= >=)
    (list 'modulo modulo)
    (list 'display display)
    (list 'newline newline)
    ; a custom load function to make it easier to run programs with a custom interpreter
    (list 'load load-inside-interpreter)
    ; Louis Reasoner's mistake is to add map as a primitive here (does not work as expected!)
    ; We could do it with a custom `map` definition that handles our typed objects.
;    (list 'map map)
    )
  )

(define (primitive-procedure-names)
  (map car (get-primitive-procedures))
  )

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc))) (get-primitive-procedures))
  )

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme (primitive-implementation proc) args)
  )


(define (load-inside-interpreter filename)
  (let ((input-port (open-input-file filename)))
    (let loop ((expr (read input-port)))
      (if (eof-object? expr)
          (begin
            (close-input-port input-port)
            'done)  ; Return 'done' when the file is fully processed
          (begin
            (eval expr the-global-environment)         ; this relies on this variable being defined by the REPL
            (loop (read input-port)))))))  ; Read and evaluate the next expression
