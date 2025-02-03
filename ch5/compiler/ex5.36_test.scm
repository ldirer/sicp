(load "ch5/compiler/compiler.scm")
(load "ch5/compiler/utils.scm")

(display-list (statements (compile '(f 1 2 3) 'val 'next)))
;(assign proc (op lookup-variable-value) (const f) (reg env))
;(assign val (const 3))
;(assign argl (op list) (reg val))
;(assign val (const 2))
;(assign argl (op cons) (reg val) (reg argl))
;(assign val (const 1))
;(assign argl (op cons) (reg val) (reg argl))
;(test (op primitive-procedure?) (reg proc))
;(branch (label primitive-branch3))
;compiled-branch2
;(assign continue (label after-call1))
;(assign val (op compiled-procedure-entry) (reg proc))
;(goto (reg val))
;primitive-branch3
;(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;after-call1

(load "ch5/compiler/ex5.36.scm")
(display-list (statements (compile '(f 1 2 3) 'val 'next)))
;(assign proc (op lookup-variable-value) (const f) (reg env))
;(assign val (const 1))
;(assign argl (op list) (reg val))
;(assign val (const 2))
;(assign argl (op adjoin-arg) (reg val) (reg argl))
;(assign val (const 3))
;(assign argl (op adjoin-arg) (reg val) (reg argl))
;(test (op primitive-procedure?) (reg proc))
;(branch (label primitive-branch6))
;compiled-branch5
;(assign continue (label after-call4))
;(assign val (op compiled-procedure-entry) (reg proc))
;(goto (reg val))
;primitive-branch6
;(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;after-call4
