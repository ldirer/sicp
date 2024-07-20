(load "ch4/environment.scm")
; assuming a frame is represented as a list of bindings instead of a pair of lists
; we reimplement *some* functions on frames and environments.
; note we make frame a 'headed list' (with a starting 'frame symbol as first element) to allow
; adding an element in place (if an empty frame is represented with the nil pointer we cannot do that)
(define (make-frame vars vals)
  (define (inner vars vals)
  (cond
    ((null? vars) '())
    (else (cons (cons (car vars) (car vals)) (inner (cdr vars) (cdr vals))))
    )
    )
  (cons 'frame (inner vars vals))
  )

(define (add-binding-to-frame! var value frame)
  ; this is where we need the headed list (similar to the table example in chapter 3)
  (if (null? (frame-bindings frame))
    ; special case because we cannot set-car! if cdr is empty
    (set-cdr! frame (list (cons var value)))
    (set-car! (frame-bindings frame) (cons var value))
    )
  )

(define (frame-bindings frame) (cdr frame))

(define (frame-variables frame)
  (map car (frame-bindings frame))
  )
(define (frame-values frame)
  (map cdr (frame-bindings frame))
  )

; a binding is a 'variable . value' pair
(define (binding-var binding) (car binding))
(define (binding-val binding) (cdr binding))
(define (set-binding-val! binding value) (set-cdr! binding value))


; lookup-variable-value does not need to change, updating the frame selectors was enough.
; set-variable-value! and define-variable! need to be adjusted however.
(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan bindings)
      (cond
        ((null? bindings) (env-loop (enclosing-environment env)))
        ((eq? var (binding-var (car bindings))) (set-binding-val! (car bindings) val))
        (else (scan (cdr bindings)))
        )
      )
    (cond
      ((eq? env the-empty-environment) (error "unbound variable" var))
      (else (scan (frame-bindings (first-frame env))))
      )
    )
  (env-loop env)
  )
(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan bindings)
      (cond
        ((null? bindings) (add-binding-to-frame! var val frame))
        ((eq? var (binding-var (car bindings))) (set-binding-val! (car bindings) val))
        (else scan (cdr bindings))
        ))

    (scan (frame-bindings frame))
    )
  )
