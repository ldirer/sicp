(load "ch5/compiler/eceval.scm")
(load "ch5/compiler/eceval_compatibility.scm")
(load "ch5/compiler/compiler_environment.scm")
; make this last because... the import setup isn't ideal and I don't want it overwritten.
(load "ch5/compiler/compiler_lexical_addressing.scm")

(define (compile-and-go expression)
  (let ((instructions (assemble (statements (compile expression 'val 'return (empty-compiler-environment))) eceval)))
    (set! the-global-environment (setup-environment))
    (set-register-contents! eceval 'val instructions)
    (set-register-contents! eceval 'flag true)
    (start eceval)
    )
  )