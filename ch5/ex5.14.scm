; Run interactively with: scheme --load "ch5/ex5.14.scm"
(load "ch5/machine.scm")
(load "ch5/stack-with-stats.scm")

(define augmented-rec-factorial-controller
  '(controller
     repl-loop
     (perform (op prompt-for-input))
     (assign n (op read))
     (perform (op initialize-stack))
     (assign continue (label fact-done))
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
     (perform (op print-stack-statistics))
     (perform (op print) (reg val))
     (goto (label repl-loop))
     )
  )

(define (print-op arg)
  (newline)
  (display arg)
  )

(define (prompt-for-input)
  (newline)
  (newline)
  (display "New factorial computation, enter a value for n:")
  (newline)
  (display "> ")
  )

(define machine (make-machine
                  '(b n val continue)
                  (list (list 'prompt-for-input prompt-for-input) (list 'print print-op) (list 'read read) (list '= =) (list '- -) (list '* *))
                  augmented-rec-factorial-controller))

(start machine)
