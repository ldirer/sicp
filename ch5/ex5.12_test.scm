(load "testing.scm")
(load "ch5/ex5.5_hand_simulate_fibo.scm")
(load "ch5/machine.scm")
(load "ch5/ex5.12.scm")


(define machine (make-machine '(b n val continue) (list (list '< <) (list '- -) (list '+ +)) fibo-controller))

(set-register-contents! machine 'n 6)
(start machine)

; 0 1 1 2 3 5 8
(check-equal "fibo machine" (get-register-contents machine 'val) 8)


(define recorded (machine 'recorded))

(check-equal "unique insts"
  (recorded 'unique-insts)
  '(
     (assign val (reg n))
     (assign val (op +) (reg val) (reg n))
     (assign n (reg val))
     (assign continue (label after-fib-n-2))
     (assign n (op -) (reg n) (const 2))
     (assign n (op -) (reg n) (const 1))
     (assign continue (label after-fib-n-1))
     (assign continue (label fib-done))
     (branch (label immediate-answer))
     (goto (reg continue))
     (goto (label fib-loop))
     (restore val)
     (restore continue)
     (restore n)
     (save val)
     (save n)
     (save continue)
     (test (op <) (reg n) (const 2))
     )
  )



(check-equal "goto only 'continue'" (recorded 'entrypoints) '(continue))

(check-equal "saved" (recorded 'saved) '(val n continue))
(check-equal "restored" (recorded 'restored) '(val continue n))
; note this is an assoc list, so a list of *pairs* (whose second element is a list).
(check-equal "assigns-by-register" (recorded 'assigns-by-register)
  '((val
      ((reg n))
      ((op +) (reg val) (reg n)))
     (n
       ((reg val))
       ((op -) (reg n) (const 2))
       ((op -) (reg n) (const 1)))
     (continue
       ((label after-fib-n-2))
       ((label after-fib-n-1))
       ((label fib-done)))
     )
  )

(assoc  'val (recorded 'assigns-by-register))

