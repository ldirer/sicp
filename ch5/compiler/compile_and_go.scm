(load "ch5/compiler/eceval.scm")
(load "ch5/compiler/eceval_compatibility.scm")

(define (compile-and-go expression)
  (let ((instructions (assemble (statements (compile expression 'val 'return)) eceval)))
    (set! the-global-environment (setup-environment))
    (set-register-contents! eceval 'val instructions)
    (set-register-contents! eceval 'flag true)
    (start eceval)
    )
  )