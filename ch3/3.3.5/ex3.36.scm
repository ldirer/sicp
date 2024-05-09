(load "ch3/3.3.5/constraint.scm")
(load "ch3/3.3.5/connector.scm")

(define a (make-connector))
(define b (make-connector))

(set-value! a 10 'user)

; this evalutes:
;(for-each-except setter inform-about-value constraints)
; that is executed in an environment that is a child of the environment created by the (make-connector) call that defined a.
; There's another environment due to the 'let' declaration inside (make-connector).
; and another one for the (set-my-value) definition
; The constraints value is part of the 'let' frame, it is connector-specific (the list of constraints associated with a).
