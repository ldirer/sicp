(load "ch4/4.2.2/lazy.scm")
(load "ch4/4.2.2/driver.scm")
; note primitives need to be loaded *after* apply
(load "ch4/4.1.4/primitives.scm")

(define the-global-environment (setup-environment))

(define input-prompt ";;; L-Eval input:")
(define output-prompt ";;; L-Eval value:")



; this shouldn't produce an error:
; (define (unless condition usual exceptional) (if condition exceptional usual))
; (unless #f 1 undefined-variable)

; or even simpler: without defining unless, this should complain about *unless* being an 'unbound variable' (not one of the arguments!)
; (unless #f 1 undefined-variable)


;(eval '+ the-global-environment)
;(eval '(+ 1 1) the-global-environment)
(eval '(define (unless condition usual exceptional) (if condition exceptional usual)) the-global-environment)
(eval '(unless #f 1 undefined-variable) the-global-environment)

(driver-loop)
