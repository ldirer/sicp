; This is meant to help go through the first exercises in the section, the implementation of the 'amb' evaluator comes later.
(load "ch4/4.3.1.amb/third_party/ch4-ambeval.scm")

; redefining things because the ambeval code loads the 'mceval' (metacircular evaluator). I replaced that load with my implementation, but I didn't
; organize the code exactly the same way, so some parts are missing.
(define the-global-environment (setup-environment))

(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedureo
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

; we can just use eval here... because we are not running the function, just defining it.
; -> looks like this does not work. eval and evalamb do not have compatible representations of procedures.
; It looks like it's the analyze-definition that is responsible for 'reading' definitions differently.
; They are interpreted differently in `apply` (eval version) and `execute-application` (ambeval version).
;(eval '(define (require p) (if (not p) (amb))) the-global-environment)
(ambeval '(define (require p) (if (not p) (amb))) the-global-environment (lambda args ()) (lambda args ()))

(driver-loop)