(load "ch4/ex4.26.scm")

(define env (setup-environment))
(check-equal "if statement sanity check" (eval '(if #t "hi" undefined-variable) env) "hi")
(check-equal "unless statement" (eval '(unless #f "hi" undefined-variable) env) "hi")
