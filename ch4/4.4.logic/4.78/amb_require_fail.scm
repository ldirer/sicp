(define (require-fail? exp) (tagged-list? exp 'require-fail))

(define (require-fail-predicate exp) (cadr exp))

(define (analyze-require-fail exp)
  (let ((pproc (analyze (require-fail-predicate exp))))
    (lambda (env succeed fail)
      (pproc
        env
        (lambda (pred-value fail2) (fail))  ; I think: don't use fail2! so we don't 'try again' inside the predicate. We only care that ONE result existed.
        (lambda () (succeed 'ok-failed fail))
        )
      )
    )
  )
