(load "testing.scm")

; I think this requires variables (how should '+' be interpreted?)
;(eval '(+ 1 3) env)

(define env '())
(check-equal "number" (eval 1 env) 1)
(check-equal "string" (eval "hi" env) "hi")
(check-equal "if truthy" (eval '(if "truthy" "ok" "nok") env) "ok"); expected: "ok"
(check-equal "if false" (eval '(if #f "ok" "nok") env) "nok"); expected: "nok"

(eval '(cond (#f "ok") (else "nok")) env) ; expected: "nok"

(cond->if '(cond (#f "ok") (else "nok")))

(eval (make-if "truthy" "then" "else") env)  ;expected: "then"