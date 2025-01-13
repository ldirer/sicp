; trying to instrumentalize the machine a bit more.
; we could imagine collecting statistics into a data structure instead of printing.
(load "ch5/machine.scm")
(load "ch5/stack-with-stats.scm")

(define augmented-rec-factorial-controller
  '(controller
     repl-loop
     (assign n (op next-input))
     (perform (op print) (reg n))

     ; EXTRA CONTROL CODE - using a sentinel value to exit the machine
     (test (op =) (reg n) (const -1))
     (branch (label exit))


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
     exit
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



; [a; b[
(define (range a b)
  (if (<= b a) (list)
              (cons a (range (+ a 1) b))
    )
  )

(define inputs (append (range 1 20) (list -1)))


(define (next-input)
  (define next (car inputs))
  (set! inputs (cdr inputs))
  next
  )

(define machine (make-machine
                  '(b n val continue)
                  (list (list 'next-input next-input) (list 'print print-op) (list 'read read) (list '= =) (list '- -) (list '* *))
                  augmented-rec-factorial-controller))

(start machine)


;n = 1..10
; total pushes: 0 2 4 6 8 10...
; The formula is pretty simple:
; total pushes = 2 * (n - 1).
; max depth = 2 * (n - 1).
