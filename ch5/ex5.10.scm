(load "ch5/machine.scm")
(load "testing.scm")


; > design a new syntax for register-machine instructions
; > Can you implement your new syntax without changing anyp art of the simulator except the syntax procedures in this section?
; --> yes yes, this is a well-designed program.
; I had to add an `assign-inst?` procedure for the syntax change I wanted to introduce.
; Also at first I wanted to do `val <- (const 1)` **without** wrapping parentheses but that's really not a good idea!
; I just didn't realize it would break the fact that each instruction is one item in the list.


; Let's change the `assign` syntax to use a fancy <- sign.
(define expt-iterative-controller-new-syntax
  '(controller
     (val <- (const 1))
     (count <- (reg n))
     expt-loop
     (test (op =) (reg count) (const 0))
     (branch (label expt-done))
     ; recursive case
     (count <- (op -) (reg count) (const 1))
     (val <- (op *) (reg b) (reg val))
     (goto (label expt-loop))
     expt-done
     ))



(define (assign-inst? inst) (and (not (null? (cdr inst))) (eq? (cadr inst) '<-)))
(trace assign-inst?)
(define (assign-reg-name assign-instruction) (car assign-instruction))
(define (assign-value-exp assign-instruction) (cddr assign-instruction))


(define a '(val <- (const 1)))
(check-equal "unit test assign-inst?" (assign-inst? a) #t)

(define iter-machine (make-machine '(b n count val continue) (list (list '= =) (list '- -) (list '* *)) expt-iterative-controller-new-syntax))


(set-register-contents! iter-machine 'n 4)
(set-register-contents! iter-machine 'b 2)
(start iter-machine)

(check-equal "iterative machine" (get-register-contents iter-machine 'val) 16)

