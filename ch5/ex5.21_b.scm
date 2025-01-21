(define (count-leaves tree)
  (define (count-iter tree n)
    (cond
      ((null? tree) n)
      ((not (pair? tree)) (+ n 1))
      (else (count-iter (cdr tree) (count-iter (car tree) n)))
      )
    )
  (count-iter tree 0)
  )


; keeping 'val' as a register to compare with previous version. It stores 'n'.
; One of the recursive call is tail-recursive: it can be replaced by a loop (without pushing `continue` onto the stack).
(define count-leaves-iter-controller
  '(controller
     (assign continue (label count-iter-done))
     (assign val (const 0))

     loop
     (test (op null?) (reg tree))
     (branch (label base-case-0))

     (save tree)
     (assign tree (op pair?) (reg tree))
     (test (op not) (reg tree))
     (branch (label base-case-1))

     ; count-iter car
     (restore tree)  ; because we used tree as a temporary register for the test

     (save continue)
     (assign continue (label after-count-iter-car))
     (save tree)
     (assign tree (op car) (reg tree))
     (goto (label loop))

     after-count-iter-car
     (restore tree)
     (restore continue)
     (assign tree (op cdr) (reg tree))
     (goto (label loop))


     base-case-0
     (goto (reg continue))

     base-case-1
     (restore tree)  ; because we used tree as a temporary register for the test
     (assign val (op +) (reg val) (const 1))
     (goto (reg continue))
     count-iter-done
     count-leaves-done
     )
  )