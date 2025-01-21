(define (append x y)
  (if (null? x)
    y
    (cons (car x) (append (cdr x) y))
    )
  )

(define (append! x y)
  (set-cdr! (last-pair x) y)
  x
  )
(define (last-pair x)
  (if (null? (cdr x))
    x
    (last-pair (cdr x)))
  )



(define append-controller
  '(
     (assign continue (label done))

     loop

     (test (op null?) (reg x))
     (branch (label base-case))
     (save x)
     (save continue)
     (assign continue (label after-recursive-call))
     (assign x (op cdr) (reg x))
     (goto (label loop))

     after-recursive-call

     (restore continue)
     (restore x)                                 ; need to restore even if we save right after because we need the correct value in x.

     (save x)                                    ; using x as a temporary register
     (assign x (op car) (reg x))
     (assign val (op cons) (reg x) (reg val))
     (restore x)

     (goto (reg continue))

     base-case

     (assign val (reg y))
     (goto (reg continue))

     done

     )
  )


; Ah! this one is I think an example where a more systematic approach (like Eli Bendersky mentions) is helpful.
; Because the inner procedure call uses the same registers as the caller, so we want to restore them correctly.
(define append!-controller
  '(

     ; save argument(s) to the stack before calling last-pair
     (save x)

     (assign continue (label after-last-pair))
     (goto (label last-pair-loop))

     after-last-pair
     ; return from last-pair - restore arguments
     (restore x)

     (perform (op set-cdr!) (reg val) (reg y))
     (assign val (reg x))
     (goto (label done))

     last-pair-loop
     (assign temp (op cdr) (reg x))
     (test (op null?) (reg temp))
     (branch (label last-pair-base-case))

     (assign x (op cdr) (reg x))
     (goto (label last-pair-loop))

     last-pair-base-case
     (assign val (reg x))
     (goto (reg continue))

     done
     )
  )
