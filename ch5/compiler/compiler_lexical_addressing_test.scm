(load "ch5/compiler/compile_and_run.scm")
(load "testing.scm")

(check-equal "list exists as primitive" (compile-and-run '(list 1)) (list 1))