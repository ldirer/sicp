; Run interactively with: scheme --load "ch5/ex5.15_test.scm"
(load "ch5/machine.scm")
(load "ch5/stack-with-stats.scm")
(load "ch5/ex5.18.scm")

; simple factorial controller
(define factorial-controller
  '(controller
     (assign continue (label fact-done))
     extra-label
     print-me-too
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

(trace-register machine 'val #t)

(start machine)
(get-register-contents machine 'val)

;1 ]=> (start machine)
;val: *unassigned*<-1
;val: 1<-2
;val: 2<-6
;val: 6<-24
;val: 24<-120
;;Value: done

