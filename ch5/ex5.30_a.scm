; a. Errors that occur in the evaluation process, such as an attempt to access an unbound variable, could be caught
; by changing the lookup operation to make it return a distinguished condition code, which cannot be a possible value of any user variable.
; The evaluator can test for this condition code and then do what is necessary to go to `signal-error`.
; Find all of the places in the evaluator where such a change is necessary and fix them. This is lots of work.

; It's not too hard to fix the unbound variable thing.
; But the exercise means "find all the places where **error handling** is necessary and fix them".
; anywhere where `error` is called.
; I haven't found too many of these. Ignoring one in a cond transform (because I'm lazy), I dealt with them I think.
; It also involves checking for possible syntax errors.

; There are LOTS OF possible syntax errors!!
; (define)
; (define a)  ; Scheme accepts this syntax, a is 'unassigned' instead of 'unbound' if we try to use it later. But our interpreter crashes.
; (lambda)
; These take us out of the evaluator repl.
; Basically for all the expressions we need to check that all arguments are present?... Sad.


; we make the value a list and test with eq? so the user cannot return an object that "looks like an error".
; an alternative could have been to return an object from lookup-variable-value.
; ('bound value) or ('unbound) (https://eli.thegreenplace.net/2008/04/04/sicp-section-54)
; -> now that I've implemented more, it seems clear that it's better to use ('error <useful things we can put into var>)
; it makes the controller code generic:
; - We still need to test everywhere but just in one line, even if multiple types of error can be returned.
; - We can put the cdr in the var register and goto signal-error.
(define UNBOUND-VARIABLE-ERROR (list 'unbound-variable-error))
(define (unbound-variable-error? value) (eq? UNBOUND-VARIABLE-ERROR value))

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
      ((eq? env the-empty-environment) UNBOUND-VARIABLE-ERROR)
      (else (let ((frame (first-frame env)))
              (scan (frame-variables frame) (frame-values frame))
              )
        )
      )
    )

  (env-loop env)
  )


(define TOO-MANY-ARGUMENTS-ERROR (list 'too-many-arguments))
(define (too-many-arguments-error? value) (eq? TOO-MANY-ARGUMENTS-ERROR value))
(define TOO-FEW-ARGUMENTS-ERROR (list 'too-few-arguments))
(define (too-few-arguments-error? value) (eq? TOO-FEW-ARGUMENTS-ERROR value))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
    (cons (make-frame vars vals) base-env)
    (if (< (length vars) (length vals))
      TOO-MANY-ARGUMENTS-ERROR
      TOO-FEW-ARGUMENTS-ERROR
      )
    )
  )


; edited to return 'ok if success. An error otherwise.
; previously only had side-effects (it was used as `(perform (op set-variable-value!) ..)`).
(define (set-variable-value! var value env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond
        ((null? vars) (env-loop (enclosing-environment env)))
        ((eq? var (car vars)) (set-car! vals value) 'ok)
        (else (scan (cdr vars) (cdr vals)))
        )
      )
    (cond
      ((eq? env the-empty-environment) UNBOUND-VARIABLE-ERROR)
      (else (let ((frame (first-frame env)))
              (scan (frame-variables frame) (frame-values frame))
              )
        )
      )
    )
  (env-loop env)
  )
