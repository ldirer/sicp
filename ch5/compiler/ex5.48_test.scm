; meant to run using input redirection: scheme < ex5.48_test.scm
(load "ch5/compiler/eceval.scm")
(load "ch5/compiler/eceval_compatibility.scm")
(load "ch5/compiler/compiler_environment.scm")
; the import is there because there's a competition between the two compilers.
; both are loaded due to lousy imports. the one loaded last will be in use, I need the lexical addressing one here.
(load "ch5/compiler/compiler_lexical_addressing.scm")

(start eceval)

; now redirected input goes to the eceval REPL
(compile-and-run '(define (factorial n) (if (= n 1) 1 (* (factorial (- n 1)) n))))

(factorial 5)
; expected: 120