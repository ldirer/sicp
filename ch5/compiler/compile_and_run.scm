(load "ch5/compiler/eceval.scm")
(load "ch5/compiler/compiler_environment.scm")
(load "ch5/compiler/eceval_compatibility.scm")
(load "ch5/compiler/compiler_lexical_addressing.scm")


;; compile the expression, run it and return the result.
;; this is an instance of a useful tool that I should have written earlier.
;; I felt like it would be useful, wasn't too sure... but it was easy to write!
;; and it is so useful to test compiled output in a file.
(define (compile-and-run expression)
  (define machine
    (make-machine '(exp env val proc argl continue unev debug arg1 arg2)
      eceval-operations
      (append
        minimal-controller-start
        (statements (compile expression 'val 'next (empty-compiler-environment)))
        )
      )
    )

  (set! the-global-environment (setup-environment))
  (start machine)

  ; returning the value! so much nicer than printing for testing. I didn't realize I would be able to do that.
  (get-register-contents machine 'val)
  )

(define minimal-controller-start
  '(
     external-entry
     (perform (op initialize-stack))
     (assign env (op get-global-environment))
     ; contrary to compile-and-go, no need to setup continue because we compile with 'next (so the program exits)
     ; also we don't jump to val, the instructions will just be appended.
     )
  )
