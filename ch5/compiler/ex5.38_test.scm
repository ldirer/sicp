(load "ch5/compiler/compiler.scm")
(load "ch5/compiler/utils.scm")
(load "testing.scm")

;(compile '(f 1 2) 'val 'next)
;(spread-arguments '(1 2))
;
;; error too many operands
;;(spread-arguments '(1 2 3 4))

(display-list (statements (spread-arguments '(1 (+ 2 3)))))

(display-list (statements (spread-arguments '((f 1) 2))))

(check-equal "save and restore correctly inserted" (statements (compile '(+ 2 (+ 1 1)) 'val 'next))
  '(
     (assign arg1 (const 2))
     (save arg1)
     (assign arg1 (const 1))
     (assign arg2 (const 1))
     (assign arg2 (op +) (reg arg1) (reg arg2))
     (restore arg1)
     (assign val (op +) (reg arg1) (reg arg2))
     )
  )


; I'm a bit confused as to env modifications that might happen when evaluating operands
; TODO why is env never saved? I think there's a bug where we don't restore env after assigning it a compiled procedure env.
; That bug would cause (define (f x) x) (+ (f 2) x) to return 4 instead of an error...
; The plan is to make the compiled code run so I can test it, then come back to this.
(display-list (statements
                (compile
                  '(begin
                     (define (f x) (+ x 1))
                     (define y 4)
                     (+ (f 2) x)
                     )
                  'val
                  'next
                  )))
;(assign val (op make-compiled-procedure) (label entry10) (reg env))
;(goto (label after-lambda9))
;entry10
;(assign env (op compiled-procedure-env) (reg proc))
;(assign env (op extend-environment) (const (x)) (reg argl) (reg env))
;(assign arg1 (op lookup-variable-value) (const x) (reg env))
;(assign arg2 (const 1))
;(assign val (op +) (reg arg1) (reg arg2))
;(goto (reg continue))
;after-lambda9
;(perform (op define-variable!) (const f) (reg val) (reg env))
;(assign val (const ok))
;(assign val (const 4))
;(perform (op define-variable!) (const y) (reg val) (reg env))
;(assign val (const ok))
;(assign proc (op lookup-variable-value) (const f) (reg env))
;(assign val (const 2))
;(assign argl (op list) (reg val))
;(test (op primitive-procedure?) (reg proc))
;(branch (label primitive-branch7))
;compiled-branch6
;(assign continue (label proc-return8))
;(assign val (op compiled-procedure-entry) (reg proc))
;(goto (reg val))
;proc-return8
;(assign arg1 (reg val))
;(goto (label after-call5))
;primitive-branch7
;(assign arg1 (op apply-primitive-procedure) (reg proc) (reg argl))
;after-call5
;(assign arg2 (op lookup-variable-value) (const y) (reg env))
;(assign val (op +) (reg arg1) (reg arg2))
