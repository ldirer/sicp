(load "ch4/environment.scm")
(load "ch4/ex4.3.scm")

(load "ch4/interpreter_test_cases.scm")

(define env (extend-environment '() '() the-empty-environment))
;((get 'eval 'if) '(if "truthy" "ok" "nok") env)
;(eval '(if "truthy" "ok" "nok") env)
(check-equal "if truthy" (eval '(if "truthy" "ok" "nok") env) "ok")
