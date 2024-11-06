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
      (let ((output (actual-value input the-global-environment)))
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
  ; the code guarantees we never get here with `object` a `thunk`.
  ; otherwise we'd need to adjust, because we can't `display` our environment objects (may contain circular references).
  ; ex circular reference: whenever a procedure is defined, the value of the procedure will contain a reference
  ; to the environment where it is defined, that's a loop.
  (if (compound-procedure? object)
    (display (list 'compound-procedure
                   (procedure-parameters object)
                   (procedure-body object)
                   '<procedure-env>
               ))
    (display object)
    ))

