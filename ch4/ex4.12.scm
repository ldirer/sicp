(load "ch4/environment.scm")
; common operations:
; walk through variables and environments, looking for a match.
; run a function on match
; define-variable! is a bit different though... it doesn't recurse.

(define (find var frame on-match on-no-match)
  (define (scan vars vals)
    (cond
      ((null? vars) (on-no-match))
      ((eq? var (car vars)) (on-match vals))
      (else (scan (cdr vars) (cdr vals)))
      )
    )
  (scan (frame-variables frame) (frame-values frame))
  )


(define (lookup-variable-value var env)
  (if (eq? env the-empty-environment)
    (error "unbound variable" var)
    (find
      var
      (first-frame env)
      (lambda (vals) (car vals))
      (lambda () (lookup-variable-value var (enclosing-environment env)))
      )
    )
  )


(define (define-variable! var value env)
  (define frame (first-frame env))
  (find
    var
    frame
    (lambda (vals) (set-car! vals value))
    (lambda () (add-binding-to-frame! var value frame))
    )
  )

(define (set-variable-value! var value env)
  (if (eq? env the-empty-environment)
    (error "unbound variable" var)
    (find
      var
      (first-frame env)
      (lambda (vals) (set-car! vals value))
      (lambda () (set-variable-value! var value (enclosing-environment env)))
      )
    )
  )
