(load "ch4/4.1.4/evaluator.scm")
(load "ch4/4.1.4/driver.scm")

(define the-global-environment (setup-environment))

;the-global-environment
(define-variable! 'a 1 the-global-environment)
(lookup-variable-value 'a the-global-environment)
(driver-loop)

