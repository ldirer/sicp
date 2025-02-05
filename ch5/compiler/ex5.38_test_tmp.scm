(load "ch5/compiler/compiler.scm")
(load "ch5/compiler/utils.scm")
(load "testing.scm")
(load "ch5/compiler/compile_and_go.scm")

(display-list (statements (compile '(+ 1 2) 'val 'next)))