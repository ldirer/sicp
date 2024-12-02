; require as a special form

; calling it require-special so I can test it separately (and not break the rest)
(define (require-special? exp) (tagged-list? exp 'require-special))

(define (require-special-predicate exp) (cadr exp))

(define (analyze-require-special exp)
  (let ((pproc (analyze (require-special-predicate exp)))
         )
    (lambda (env succeed fail)
      (pproc
        env
        (lambda (pred-value fail2)
          (if pred-value
            (succeed 'ok fail2)
            (fail2)
            )
          )
        fail)
      )
    )
  )
