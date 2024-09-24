(load "ch4/ex4.16.scm")

(define env (extend-environment '() '() the-empty-environment))
(define-variable! 'a '*unassigned* env)
(lookup-variable-value 'a env)
; expected: error "accessing unassigned variable a"
