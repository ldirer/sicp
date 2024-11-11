(load "ch4/4.2.3/ex4.33.scm")
(load "ch4/4.1.4/primitives.scm")

(define the-global-environment (setup-environment))

(eval '(load "ch4/4.2.3/lazylist.scm") the-global-environment)
;(trace eval)
(eval ''cons the-global-environment)

(eval '(begin (newline)
              (display (car '(a b c)))
         )
  the-global-environment)
