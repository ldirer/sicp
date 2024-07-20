(load "ch4/environment.scm")
(load "testing.scm")

; remove a symbol from the environment in which it is being evaluated.
; I think it is simpler to limit 'unbinding' to the current frame.
; Other environments might rely on parent frames, if we modify it it might have all sorts of unpredictable side effects.
; Although I guess that would be true of any variable modified in a parent environment.
; I'm not sure what a good use case for unbinding in a parent environment would be though...
; So I would limit it to the current frame.
(define (make-unbound! var env)
  (define frame (first-frame env))
  (define (scan vars vals)
    (cond
      ((null? vars) (error "variable not found in first frame of environment: " var))
      ((eq? var (car vars))
        ; remove variable-value pair
        ; if it's the only element in the list we need to create a new frame! can't modify it in-place, sad.
        (if (null? (cdr vars))
          (set-first-frame! env (make-frame '() '()))
          (begin
            (set-car! vars (cadr vars))
            (set-car! vals (cadr vals))
            )
          )
        )
      (else scan (cdr vars) (cdr vals)))
    )

  (scan (frame-variables frame) (frame-values frame))
  )


(define parent (extend-environment '(a) '(2) the-empty-environment))
(define env (extend-environment '(a) '(1) parent))
(check-equal "sanity check" (lookup-variable-value 'a env) 1)

(make-unbound! 'a env)

(check-equal "value should be the value from parent" (lookup-variable-value 'a env) 2)
