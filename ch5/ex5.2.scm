; > Use the register-machine language to describe the iterative factorial machine of exercise 5.1

(controller
  (assign p (constant 1))
  (assign c (constant 1))
  test-counter
  (test (op >) (reg c) (reg n))
  (branch (label factorial-done))
  (assign p (op *) (reg p) (reg c))
  (assign c (op +) (reg c) (constant 1))
  (goto (label test-counter))
  factorial-done
  )



