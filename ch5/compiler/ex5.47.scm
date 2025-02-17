(load "ch5/compiler/compile_and_go.scm")
(load "ch5/compiler/utils.scm")

(define expression '(define (f) (g)))
(display-list (statements (compile expression 'val 'return the-empty-compiler-environment)))

(compile-and-go expression)

;E
;(reg 'name)

(define (g) 'success)
(f)

;(debug)
;H
;u
;u
;E
;(instruction-text (car insts))