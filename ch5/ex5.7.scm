(load "ch5/ex5.4.scm")
(load "ch5/machine.scm")
(load "testing.scm")

(define rec-machine (make-machine '(b n val continue) (list (list '= =) (list '- -) (list '* *)) recursive-controller))
(define iter-machine (make-machine '(b n count val continue) (list (list '= =) (list '- -) (list '* *)) iterative-controller))

(set-register-contents! rec-machine 'n 4)
(set-register-contents! rec-machine 'b 2)
(start rec-machine)

(set-register-contents! iter-machine 'n 4)
(set-register-contents! iter-machine 'b 2)
(start iter-machine)

(check-equal "recursive machine" (get-register-contents rec-machine 'val) 16)
(check-equal "iterative machine" (get-register-contents iter-machine 'val) 16)

