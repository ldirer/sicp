(load "testing.scm")

; file holding test cases, then I import it after loading different definitions for the operations being tested
; I guess it could just have been a function.

(define env (extend-environment '() '() the-empty-environment))
(define env-2-deep (extend-environment (list 'a 'c) (list "a in env-2-deep" "c in env-2-deep") env))

(define-variable! 'd "d" env)
(check-equal "lookup newly-defined variable" (lookup-variable-value 'd env) "d")

(define-variable! 'b "b" env)
(check-equal "sanity-check we can define a second new variable" (lookup-variable-value 'b env) "b")

;(define (define-variable! var value env)
;(set-variable-value! var value env)
(check-equal "lookup variable in current env" (lookup-variable-value 'a env-2-deep) "a in env-2-deep")
(check-equal "lookup variable in parent env" (lookup-variable-value 'b env-2-deep) "b")

(display "\n")
(display (first-frame env-2-deep))
(display "\n")

(display "(first-frame env)=")
(display (first-frame env))
(display "\n")

(set-variable-value! 'b "new b" env-2-deep)
(display "(first-frame env)=")
(display (first-frame env))
(display "\n")
(set-variable-value! 'c "new c" env-2-deep)

(check-equal "after set variable value" (lookup-variable-value 'b env-2-deep) "new b")
(check-equal "after set variable value in parent env, reading directly from parent env reflects the change" (lookup-variable-value 'b env) "new b")
