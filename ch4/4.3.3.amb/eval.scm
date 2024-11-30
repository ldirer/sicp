(load "ch4/4.1.7/analyze.scm")
(define (eval exp env) ((analyze exp) env))
