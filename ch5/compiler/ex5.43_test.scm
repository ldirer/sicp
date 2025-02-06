(load "testing.scm")
(load "ch5/compiler/ex5.43.scm")
(load "ch5/compiler/compiler_lexical_addressing.scm")
(load "ch5/compiler/utils.scm")
(load "ch5/compiler/ex5.43_test_utils.scm")

(define test-code
  '(
     (define u 1)
     (define v 2)
     (+ u v)
     )
  )

(check-equal "in-body defines converted to let" (scan-out-defines test-code)
  '((let ((u '*unassigned*) (v '*unassigned*)) (set! u 1) (set! v 2) (+ u v)))
  )

(check-equal "scan out defines in lambda"
  (scan-out-defines (lambda-body '(lambda ()
                                    (define u 1)
                                    (define v 2)
                                    (+ u v))))
  '((let ((u '*unassigned*) (v '*unassigned*)) (set! u 1) (set! v 2) (+ u v)))
  )

(check-equal "does not add empty let" (scan-out-defines '((+ u v))) '((+ u v)))

;(display-list (statements (compile '(define (f x) ((lambda (y) (+ y x)) 2)) 'val 'next the-empty-compiler-environment)))
;; instructions do contain only lexical lookups: this is what we want.
;(assign val (op make-compiled-procedure) (label entry2) (reg env))
;(goto (label after-lambda1))
;entry2
;(assign env (op compiled-procedure-env) (reg proc))
;(assign env (op extend-environment) (const (x)) (reg argl) (reg env))
;(assign proc (op make-compiled-procedure) (label entry4) (reg env))
;(goto (label after-lambda3))
;entry4
;(assign env (op compiled-procedure-env) (reg proc))
;(assign env (op extend-environment) (const (y)) (reg argl) (reg env))
;(assign arg1 (op lexical-address-lookup) (const (0 0)) (reg env))
;(assign arg2 (op lexical-address-lookup) (const (1 0)) (reg env))
;(assign val (op +) (reg arg1) (reg arg2))
;(goto (reg continue))
;after-lambda3
;(assign val (const 2))
;(assign argl (op list) (reg val))
;(test (op primitive-procedure?) (reg proc))
;(branch (label primitive-branch7))
;compiled-branch6
;(assign val (op compiled-procedure-entry) (reg proc))
;(goto (reg val))
;primitive-branch7
;(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;(goto (reg continue))
;after-call5
;after-lambda1
;(perform (op define-variable!) (const f) (reg val) (reg env))
;(assign val (const ok))


(define test-instructions (statements (compile '(define (f x) (define y 2) (+ x y)) 'val 'next the-empty-compiler-environment)))
;(display-list test-instructions)
(check-equal "x and y both looked up using lexical lookup" (count-substring (instructions->string test-instructions) "lexical") 2)
(check-equal "no regular variable lookup" (count-substring (instructions->string test-instructions) "lookup-variable-value") 0)