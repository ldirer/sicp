(load "ch4/4.1.4/evaluator.scm")
;overwrite eval with the version that accepts 'put'
(load "ch4/ex4.3.scm")
; Ben is correct that in applicative order, `unless` can still be implemented as a special form.
; Alyssa says it would not be a procedure that can be used in conjunction with higher-order procedures.
; She's correct, namely we could not do things like:
; (map unless conditions usual-values exceptional-values)


; An example where it might be useful to have `unless` available as a procedure instead of a special form: see above the `map unless` call.
; not sure how useful that is though.
; One other thing is we could overwrite `unless`? Not sure how useful that is but perhaps for testing?



; add special form unless as a derived expression

; syntax: unless condition usual-value exceptional-value
(define (unless-condition expr) (cadr expr))
(define (unless-usual expr) (caddr expr))
(define (unless-exceptional expr) (cadddr expr))

(define (unless->if expr)
  (make-if (unless-condition expr) (unless-exceptional expr) (unless-usual expr))
  )

(define (unless-pkg)
  (define (eval-unless expr env) (eval (unless->if expr) env))

  (put 'eval 'unless eval-unless)
)

(unless-pkg)

