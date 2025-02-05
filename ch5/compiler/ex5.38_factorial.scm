
(load "ch5/compiler/compiler_lexical_addressing.scm")
(load "ch5/compiler/utils.scm")
(load "ch5/compiler/compiler_environment.scm")
(load "ch5/compiler/ex5.38.scm")

(define factorial-code (compile '(define (factorial n)
                                   (if (= n 1)
                                     1
                                     (* (factorial (- n 1)) n))
                                   )
                         'val
                         'next
                         (empty-compiler-environment)
                         ))

(display-list (statements factorial-code))

; there are a lot fewer instructions in this version of factorial!
; - procedure calls are verbose because there is always the test with the two branches (primitive and compiled procedure)
; - as a bonus we never need to save proc, env
; To be fair:
; - I don't know if this version of factorial would work! I did not run it. Maybe I should look into executing compiled programs...
; --> now tested, it works
; - It seems like the save env could be removed from the ex5.33 version? I don't know if it's a bug in my implementation.

;(base) laurent@pop-os:~/programming/sicp (main)wc -l ch5/compiler/ex5.33_factorial_instructions.scm ch5/compiler/ex5.38_factorial_instructions.scm
;  79 ch5/compiler/ex5.33_factorial_instructions.scm
;  41 ch5/compiler/ex5.38_factorial_instructions.scm

