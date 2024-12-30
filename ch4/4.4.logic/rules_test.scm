(load "ch4/4.4.logic/rules.scm")
(load "ch4/4.4.logic/syntax.scm")
(load "ch4/4.4.logic/frames.scm")

(unify-match '(hop (? a)) '(hop 1) '())
;Value: (((? a) . 1))
