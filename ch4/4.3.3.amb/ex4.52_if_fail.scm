(define (if-fail? exp) (tagged-list? exp 'if-fail))

(define (if-fail-first exp) (cadr exp))
(define (if-fail-fallback exp) (caddr exp))

(define (analyze-if-fail exp)
  (let ((first (analyze (if-fail-first exp)))
         (fallback (analyze (if-fail-fallback exp)))
         )
    (lambda (env succeed fail)
      (first
        env
        succeed
        (lambda ()
          (fallback env succeed fail)
          )
        )
      )
    )
  )
