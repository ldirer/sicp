(define (count-leaves tree)
  (cond
    ((null? tree) 0)
    ((not (pair? tree)) 1)
    (else (+
            (count-leaves (car tree))
            (count-leaves (cdr tree))
            ))
    )
  )


; The 'double recursion' makes it similar to the fibonacci example
(define count-leaves-controller-with-temp
  '(controller
     (assign continue (label count-leaves-done))
     loop
     (test (op null?) (reg tree))
     (branch (label base-case-0))

     ; not (pair? tree) is more than one instruction
     ; I took the easy road by using a temp register for now.
     (assign temp (op pair?) (reg tree))
     (test (op not) (reg temp))
     (branch (label base-case-1))

     (save continue)
     (assign continue (label after-count-leaves-car))
     (save tree)
     (assign tree (op car) (reg tree))
     (goto (label loop))

     after-count-leaves-car
     ; no save continue, we already saved it before the car recursive call
     (restore tree)
     (save val)

     (assign continue (label after-count-leaves-cdr))
     (assign tree (op cdr) (reg tree))
     (goto (label loop))

     after-count-leaves-cdr
     (assign temp (reg val))
     (restore val)        ; restore the result of count-leaves car into val
     (restore continue)   ; restore the saved continue before recursive car call.
     (assign val (op +) (reg val) (reg temp))
     (goto (reg continue))

     base-case-0
     (assign val (const 0))
     (goto (reg continue))

     base-case-1
     (assign val (const 1))
     (goto (reg continue))
     count-leaves-done
     )
  )


; version without an extra register
(define count-leaves-controller
  '(controller
     (assign continue (label count-leaves-done))
     loop
     (test (op null?) (reg tree))
     (branch (label base-case-0))

     ; not (pair? tree) is more than one instruction
     ; we can use any register as long as we save its value and restore it first thing in every branch.
     (save tree)
     (assign tree (op pair?) (reg tree))
     (test (op not) (reg tree))
     (branch (label base-case-1))

     ; count-leaves car
     (restore tree)  ; because we used tree as a temporary register for the test

     (save continue)
     (assign continue (label after-count-leaves-car))
     (save tree)
     (assign tree (op car) (reg tree))
     (goto (label loop))

     after-count-leaves-car
     ; no save continue, we already saved it before the car recursive call
     (restore tree)
     (save val)

     (assign continue (label after-count-leaves-cdr))
     (assign tree (op cdr) (reg tree))
     (goto (label loop))

     after-count-leaves-cdr
     ; note how we don't save tree. It has already been saved where it was needed?
     (restore tree)        ; restore the result of count-leaves car (that was a `val` register) into *tree*.
     (assign val (op +) (reg val) (reg tree))
     (restore continue)   ; restore the saved continue before recursive car call.
     (goto (reg continue))

     base-case-0
     (assign val (const 0))
     (goto (reg continue))

     base-case-1
     (restore tree)  ; because we used tree as a temporary register for the test
     (assign val (const 1))
     (goto (reg continue))
     count-leaves-done
     )
  )