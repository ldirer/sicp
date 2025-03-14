(load "ch4/4.1.4/primitives.scm")
;; A longer list of primitives -- suitable for running everything in 4.3
;; Overrides the list in ch4-mceval.scm
;; Has Not to support Require; various stuff for code in text (including
;;  support for Prime?); integer? and sqrt for exercise code;
;;  eq? for ex. solution

(define (get-primitive-procedures)
  ; evaluate is a hack for ex4.78.
  (define (evaluate expr env)
    (define return-value 'unset)
    (ambeval expr env (lambda (value fail) (set! return-value value)) (lambda () (error "ambiguous values not allowed in this context")))
    return-value
    )

  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list 'list list)
        (list 'memq memq)
        (list 'member member)
        (list 'not not)
        (list '+ +)
        (list '- -)
        (list '* *)
        (list '= =)
        (list '> >)
        (list '>= >=)
        (list 'abs abs)
        (list 'remainder remainder)
        (list 'integer? integer?)
        (list 'sqrt sqrt)
        (list 'eq? eq?)
        ;;      more primitives
        (list '< <)
        (list '<= <=)
        (list '/ /)
        (list 'modulo modulo)
        (list 'display display)
        (list 'newline newline)
        (list 'runtime runtime)
        (list 'and and-func)
        (list 'or or-func)
        (list 'apply apply)
        (list 'load load-inside-ambeval)
        (list 'pp pp)
        (list 'list? list?)
        (list 'random random)
        (list 'length length)
        (list 'even? even?)
        ; added to try to run the amb-based implementation of the logic interpreter (ex4.78)
        ; Since the whole logic interpreter code runs within the amb eval interpreter, that's quite a lot of primitives.
        ; possibly code paths that I haven't triggered in my tests would require adding things here!
        (list 'read read)
        (list 'pair? pair?)
        (list 'symbol? symbol?)
        (list 'symbol->string symbol->string)
        (list 'string->symbol string->symbol)
        (list 'string=? string=?)
        (list 'substring substring)
        (list 'open-input-file open-input-file)
        (list 'eof-object? eof-object?)
        (list 'close-input-port close-input-port)
        (list 'equal? equal?)
        (list 'caar caar)
        (list 'cadr cadr)
        (list 'cddr cddr)
        (list 'caddr caddr)
        (list 'cadar cadar)
        (list 'caddar caddar)
        (list 'string-length string-length)
        (list 'string-append string-append)
        (list 'assoc assoc)
        (list 'number? number?)
        (list 'append append)
        (list 'error error)
        (list 'apply apply)
        ; because we use the environment with our custom evaluate, it needs to be an 'ambeval' environment
        ; exposing it directly is pretty terrible... Whatever.
        ; also doing it lazily to avoid circular definition issues.
        (list 'eval (lambda (expr) (evaluate expr the-global-environment)))
    ))

; we need functions for 'and/or' if we want to add them as primitives (functions and not special forms)
; they would be better as special forms for short circuit evaluation but we did not handle them.
(define (and-func a b)
  (if a b #f)
  )
(define (or-func-binary a b)
  (if a #t b)
  )

(define (or-func a b . args)
  (if (null? args)
    (or-func-binary a b)
    (apply-in-underlying-scheme or-func (or-func-binary a b) (car args) (cdr args))
    )
  )


(define (load-inside-ambeval filename)
  (let ((input-port (open-input-file filename)))
    (let loop ((expr (read input-port)))
      (if (eof-object? expr)
        (begin
          (close-input-port input-port)
          'done-loading-file)
        (begin
          (ambeval expr the-global-environment (lambda args '()) (lambda args '()))
          (loop (read input-port)))))))  ; Read and evaluate the next expression

