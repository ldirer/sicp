; This is meant to help go through the first exercises in the section, the implementation of the 'amb' evaluator comes later.
(load "ch4/4.3.3.amb/eval.scm")
(load "ch4/4.3.3.amb/primitives.scm")
(load "ch4/4.3.3.amb/driver.scm")

(define the-global-environment (setup-environment))

(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>))
      (display object)))

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

(ambeval '(define (require p) (if (not p) (amb))) the-global-environment (lambda args ()) (lambda args ()))

(driver-loop)