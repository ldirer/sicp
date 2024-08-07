(load "ch4/4.1.4/evaluator.scm")

(define input-prompt ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (eval input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop)
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
  (if (compound-procedure? object)

    (display (list 'compound-procedure
                   (procedure-parameters object)
                   (procedure-body object)
                   '<procedure-env>
               ))
    (display object)
    ))

