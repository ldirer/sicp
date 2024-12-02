(define (permanent-assignment? exp) (tagged-list? exp 'permanent-set!))

(define (analyze-permanent-assignment exp)
  (let ((var (assignment-variable exp))
         (vproc (analyze (assignment-value exp)))
         )
    (lambda (env succeed fail)
      (vproc
        env
        (lambda (new-value fail2)
          (set-variable-value! var new-value env)
          ; no backtracking here
          (succeed 'ok fail2)
          )
        fail
        )
      )
    )
  )
