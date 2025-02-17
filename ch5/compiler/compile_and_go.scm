(load "ch5/compiler/eceval.scm")
(load "ch5/compiler/eceval_compatibility.scm")
(load "ch5/compiler/compiler_environment.scm")
; make this last because... the import setup isn't ideal and I don't want it overwritten.
(load "ch5/compiler/compiler_lexical_addressing.scm")

(set! FLAGS (cons (cons 'open-coded-primitives #t) FLAGS))
; eceval alone already handles errors in the repl.
; the flag requires different error handling controller instructions.
; see comments in compiler code and compile-and-run for details.
; introduced because the repl assumes the val register contains the error, but compiled code might use other registers.
(set! FLAGS (cons (cons 'unbound-variable-error-handling #f) FLAGS))

(define (compile-and-go expression)
  (let ((instructions (assemble (statements (compile expression 'val 'return the-empty-compiler-environment)) eceval)))
    (set! the-global-environment (setup-environment))
    (set-register-contents! eceval 'val instructions)
    (set-register-contents! eceval 'flag true)
    (start eceval)
    )
  )