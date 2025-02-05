(load "testing.scm")
(load "ch5/compiler/compiler_environment.scm")

(check-equal "test 1" (find-variable 'c '((y z) (a b c d e) (x y))) (make-lexical-address 1 2))
(check-equal "test 2" (find-variable 'x '((y z) (a b c d e) (x y))) (make-lexical-address 2 0))
(check-equal "test 3" (find-variable 'w '((y z) (a b c d e) (x y))) 'not-found)
