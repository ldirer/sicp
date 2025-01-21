(load "testing.scm")
(load "ch5/machine.scm")
(load "ch5/ex5.22_a.scm")

(define machine (make-machine
                  '(x
                     y
                     val
                     continue)
                  (list
                    (list 'car car)
                    (list 'cdr cdr)
                    (list 'cons cons)
                    (list 'null? null?)
                    )
                  append-controller))


(define x (list 1 2))
(define y (list 3 4))
(set-register-contents! machine 'x x)
(set-register-contents! machine 'y y)

(start machine)
(check-equal "simple append" (get-register-contents machine 'val) (list 1 2 3 4))


(set-register-contents! machine 'x (list))
(set-register-contents! machine 'y (list))

(start machine)
(check-equal "simple append empty lists" (get-register-contents machine 'val) (list))

