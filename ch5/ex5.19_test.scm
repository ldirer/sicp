(load "testing.scm")
(load "ch5/machine.scm")
(load "ch5/stack-with-stats.scm")
(load "ch5/ex5.19.scm")

; simple factorial controller
(define factorial-controller
  '(controller
     (assign continue (label fact-done))
     fact-loop
     (test (op =) (reg n) (const 1))
     (branch (label fact-base-case))

     ; prepare for recursive call
     (save continue)
     (save n)
     (assign n (op -) (reg n) (const 1))
     (assign continue (label after-fact))
     (goto (label fact-loop))

     after-fact
     ; undo the 'save' that we did in *our* level of recursion. Order matters! we are sharing a stack here.
     (restore n)
     (restore continue)
     (assign val (op *) (reg n) (reg val))
     (goto (reg continue))

     fact-base-case
     ; note there's no 'restore continue' here.
     (assign val (const 1))
     (goto (reg continue))
     fact-done
     )
  )



(define machine (make-machine
                  '(b n val continue)
                  (list (list '= =) (list '- -) (list '* *))
                  factorial-controller))

(set-register-contents! machine 'n 5)

(set-breakpoint machine 'controller 1)
(start machine)
(proceed-machine machine)

(check-equal "can hit breakpoint and proceed" (get-register-contents machine 'val) 120)

(cancel-all-breakpoints machine)
(set-register-contents! machine 'n 5)

(set-breakpoint machine 'after-fact 3)
(cancel-breakpoint machine 'after-fact 3)

(check-equal "can cancel a specific breakpoint" (start machine) 'done)
(check-equal "sanity check result after canceled breakpoint" (get-register-contents machine 'val) 120)


(cancel-all-breakpoints machine)
(set-register-contents! machine 'n 6)

(set-breakpoint machine 'after-fact 3)
(start machine)
(check-equal "can hit breakpoint in loop and proceed" (get-register-contents machine 'val) 1)
(proceed-machine machine)
(check-equal "can hit breakpoint in loop and proceed" (get-register-contents machine 'val) 2)
(proceed-machine machine)
(check-equal "can hit breakpoint in loop and proceed" (get-register-contents machine 'val) 6)
(proceed-machine machine)
(check-equal "can hit breakpoint in loop and proceed" (get-register-contents machine 'val) 24)
(proceed-machine machine)
(check-equal "can hit breakpoint in loop and proceed" (get-register-contents machine 'val) 120)
; cheating!
(set-register-contents! machine 'val 1000)
(proceed-machine machine)
(check-equal "can proceed after register change" (get-register-contents machine 'val) 6000)

(check-equal "proceed returns when already done" (proceed-machine machine) 'already-done)
