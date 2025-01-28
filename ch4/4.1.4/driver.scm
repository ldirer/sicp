(load "utils.scm")

(define input-prompt ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")

(define (error-handler condition)
  (display (condition/report-string condition)) ; Print the error message
  (newline)
  (display "ignoring error so we can keep using the repl")
  ; same command as in the scheme REPL to 'return to read-eval-print level 1'
  ; not what we want to do here though! We want to stay in our custom repl.
  ; (restart 1)
  (driver-loop)
  )

(define (driver-loop)
  (bind-default-condition-handler '() error-handler)
  (define (loop)
    (prompt-for-input input-prompt)
    (let ((input (read)))
      (let ((output (eval input the-global-environment)))
        (announce-output output-prompt)
        (user-print output)))
    (loop)
    )
  (loop)
  )


(define (prompt-for-input prompt)
  (newline)
  (newline)
  (display prompt)
  (newline)
  )

(define (announce-output prompt)
  (newline)
  (display prompt)
  (newline)
  )


(define (user-print object)
  (cond
    ((compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>
                 )))
    ((thunk? object) (display (list 'thunk (thunk-expr object) '<thunk-env>)))
    (else (display object))
    )
  )

