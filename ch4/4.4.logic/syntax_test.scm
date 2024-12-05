
(load "testing.scm")
(load "ch4/4.4.logic/syntax.scm")

(check-equal "test expand ?"  (expand-question-mark '?x) '(? x))