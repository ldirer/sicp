(load "ch4/4.3.3.amb/analyze.scm")
(define (ambeval exp env succeed fail) ((analyze exp) env succeed fail))
