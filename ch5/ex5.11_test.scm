(load "ch5/machine.scm")
(load "ch5/ex5.11.scm")
(load "testing.scm")


(define test-controller-all-good
  '(controller
     (assign x (const 1))
     (save x)
     (restore x)
     )
  )

(define test-controller-error
  '(controller
     (assign x (const 1))
     (save x)
     (restore y)
     )
  )

(define test-machine (make-machine '(x y) (list) test-controller-all-good))
(check-equal "sanity check" (start test-machine) 'done)


(define test-machine (make-machine '(x y) (list) test-controller-error))
(start test-machine)
; expected: an error!
