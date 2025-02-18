; rlwrap scheme --load "ch5/compiler/ex5.49_rcepl.scm"
;> Design a register machine that performs a read-compile-execute-print loop.
; Good to see **how little code we need** to build this loop!

(load "ch4/interpreter_preload.scm")
(load "ch5/eceval_ops.scm")
(load "ch5/compiler/ex5.49_read_compile_execute_print_controller.scm")
(load "ch5/machine.scm")
(load "ch5/ex5.17.scm")
(load "ch5/stack-with-stats.scm")
(load "ch5/compiler/eceval_compatibility.scm")
(load "ch5/compiler/compiler_lexical_addressing.scm")

; we could add error handling as in compile_and_run.scm, but until then the flag needs to be off.
(set! FLAGS (cons (cons 'unbound-variable-error-handling #f) FLAGS))
(set! FLAGS (cons (cons 'open-coded-primitives #t) FLAGS))

(define rcepl-machine
  (make-machine
    '(exp env val proc argl continue unev debug arg1 arg2 compapp)
    eceval-operations
    rcepl-controller
    )
  )

(start rcepl-machine)


;;;; Read-Compile-Execute input:
;(define (factorial n) (if (= n 1) n (* (factorial (- n 1)) n)))
;
;(total-pushes = 0 maximum-depth = 0)
;;;; Read-Compile-Execute value:
;ok
;
;;;; Read-Compile-Execute input:
;(factorial 6)
;
;(total-pushes = 10 maximum-depth = 10)
;;;; Read-Compile-Execute value:
;720