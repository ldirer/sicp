(load "ch5/machine.scm")
(load "ch5/ex5.11_c_one_stack_per_register.scm")
(load "testing.scm")


(define test-controller
  '(controller
     (assign x (const 1))
     (assign y (const 2))
     (save x)
     (save y)

     ; values to make sure the tests fail if we just break save and restore entirely :)
     (assign x (const 100))
     (assign y (const 100))

     ; restore in the 'wrong order'
     (restore x)
     (restore y)
     )
  )

(define test-machine (make-machine '(x y) (list) test-controller))
(start test-machine)
(check-equal "register values restored from dedicated stacks x" (get-register-contents test-machine 'x) 1)
(check-equal "register values restored from dedicated stacks y" (get-register-contents test-machine 'y) 2)


