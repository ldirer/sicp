(define gc-controller
  '(begin-garbage-collection
     (assign free (const 0))
     (assign scan (const 0))
     (assign old (reg root))
     (assign relocate-continue (label reassign-root))
     (goto (label relocate-old-result-in-new))

     reassign-root
     (assign root (reg new))
     (goto (label gc-loop))


     gc-loop
     (test (op =) (reg scan) (reg free))
     (branch (label gc-flip))
     ;note: this is put in *old* because at this stage it still points to old data. If the car contained p5, we copied it
     ; to new memory but it still refers to old memory.
     ; so we will go relocate *that* (p5) and then update the address in new-cars[scan].
     (assign old (op vector-ref) (reg new-cars) (reg scan))
     (assign relocate-continue (label update-car))
     (goto (label relocate-old-result-in-new))


     update-car
     ; in register new is the new address for the value car points to. We already moved it at this stage.
     (perform (op vector-set!) (reg new-cars) (reg scan) (reg new))
     (assign old (op vector-ref) (reg new-cdrs) (reg scan))
     (assign relocate-continue (label update-cdr))
     (goto (label relocate-old-result-in-new))


     update-cdr
     (perform (op vector-set!) (reg new-cdrs) (reg scan) (reg new))
     (assign scan (op +) (reg scan) (const 1))
     (goto (label gc-loop))

     relocate-old-result-in-new

     (test (op pointer-to-pair?) (reg old))
;     (perform (op print) (const pair-test) (reg flag) (reg old))
     (branch (label pair))
     ; if it's not a pair, there is nothing to do with the value.
     ; If I understand correctly, the code will still do an assignment with (in the case of update-car)
     ; (perform (op vector-set!) (reg new-cars) (reg scan) (reg new))
     ; when really we already have the value in (reg new) at that position.
     (assign new (reg old))
     (goto (reg relocate-continue))

     pair
     (assign oldcr (op vector-ref) (reg the-cars) (reg old))
     (test (op broken-heart?) (reg oldcr))
;     (perform (op print) (const broken-heart-test) (reg flag))
     (branch (label already-moved))
     (assign new (reg free))   ; new location for pair
     ;; Update free pointer
     (assign free (op +) (reg free) (const 1))
     ;; Copy the car and cdr to new memory
     (perform (op vector-set!) (reg new-cars) (reg new) (reg oldcr))
     (assign oldcr (op vector-ref) (reg the-cdrs) (reg old))
     (perform (op vector-set!) (reg new-cdrs) (reg new) (reg oldcr))
     ;; Construct the broken heart.
     (perform (op vector-set!) (reg the-cars) (reg old) (const broken-heart))
     (perform (op vector-set!) (reg the-cdrs) (reg old) (reg new))

     (goto (reg relocate-continue))

     already-moved
     (assign new (op vector-ref) (reg the-cdrs) (reg old))
     (goto (reg relocate-continue))


     gc-flip
     ; swap the-cdrs with new-cdrs and the-cars with new-cars
     (assign temp (reg the-cdrs))
     (assign the-cdrs (reg new-cdrs))
     (assign new-cdrs (reg temp))
     ; the-cars
     (assign temp (reg the-cars))
     (assign the-cars (reg new-cars))
     (assign new-cars (reg temp))
     )
  )
