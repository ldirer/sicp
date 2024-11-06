(load "ch4/4.2.2/lazy.scm")
(load "ch4/4.1.4/primitives.scm")

(define test-env (setup-environment))
(delay-it 'undefined-variable test-env)
(actual-value 'undefined-variable test-env)

(eval '(define (unless condition usual exceptional) (if condition exceptional usual)) test-env)
(display (delay-it 'unless test-env))

