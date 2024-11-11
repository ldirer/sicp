(load "ch4/4.2.2/lazy.scm")
(load "ch4/4.2.2/driver.scm")
; note primitives need to be loaded *after* apply
(load "ch4/4.1.4/primitives.scm")

(define the-global-environment (setup-environment))

(define input-prompt ";;; L-Eval input:")
(define output-prompt ";;; L-Eval value:")
