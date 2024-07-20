;code from section 4.1.3
(define (apply-primitive-procedure proc args)
  ;  todo
  '()
  )

(define (primitive-procedure? proc)
  ;  todo
  '()
  )


(define (make-procedure parameters body env)
  (list 'procedure parameters body env)
  )

(define (compound-procedure? p)
  (tagged-list? p 'procedure))

(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (cadr p))
(define (procedure-environment p) (cadddr p))




(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond
        ((null? vars) (env-loop (enclosing-environment env)))
        ((eq? var (car vars)) (car vals))
        (else (scan (cdr vars) (cdr vals)))
        )
      )
    (cond
      ((eq? env the-empty-environment) (error "unbound variable" var))
      (else (let ((frame (first-frame env)))
              (scan (frame-variables frame) (frame-values frame))
              )
        )
      )
    )

  (env-loop env)
  )

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
    (cons (make-frame vars vals) base-env)
    (if (< (length vars) (length vals))
      (error "too many arguments supplied" vars vals)
      (error "too few arguments supplied" vars vals)
      )
    )
  )

(define (define-variable! var value env)
  ; we want to update the variable value if it already exists in this frame
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond
        ((null? vars) (add-binding-to-frame! var value frame))
        ((eq? var (car vars)) (set-car! vals value))
        (else scan (cdr vars) (cdr vals))
        ))

    (scan (frame-variables frame) (frame-values frame))
    )
  )

(define (set-variable-value! var value env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond
        ((null? vars) (env-loop (enclosing-environment env)))
        ((eq? var (car vars)) (set-car! vals value))
        (else (scan (cdr vars) (cdr vals)))
        )
      )
    (cond
      ((eq? env the-empty-environment) (error "unbound variable" var))
      (else (let ((frame (first-frame env)))
              (scan (frame-variables frame) (frame-values frame))
              )
        )
      )
    )
  (env-loop env)
  )

; an environment is a list of frames
(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define (set-first-frame! env frame) (set-car! env frame))
(define the-empty-environment '())

;frames - procedures make the code more readable but it's not a clean data abstraction here
(define (make-frame vars vals) (cons vars vals))

(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))

(define (add-binding-to-frame! var value frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons value (cdr frame)))
  )



