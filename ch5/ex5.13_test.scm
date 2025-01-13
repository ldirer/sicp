(load "testing.scm")
(load "ch5/ex5.5_hand_simulate_fibo.scm")
(load "ch5/machine.scm")
(load "ch5/ex5.13.scm")


(define machine (make-machine '(b n val continue) (list (list '< <) (list '- -) (list '+ +)) fibo-controller))

(set-register-contents! machine 'n 6)
(start machine)

; 0 1 1 2 3 5 8
(check-equal "fibo machine" (get-register-contents machine 'val) 8)

