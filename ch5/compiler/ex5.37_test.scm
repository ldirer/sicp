(load "ch5/compiler/compiler.scm")
(load "ch5/compiler/utils.scm")


(display-list (statements (compile '(+ 1 2) 'val 'next)))
;(assign proc (op lookup-variable-value) (const +) (reg env))
;(assign val (const 2))
;(assign argl (op list) (reg val))
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
(load "ch5/compiler/ex5.37.scm")
(display-list (statements (compile '(+ 1 2) 'val 'next)))
;(save continue)
;(save env)
;(save continue)
;(assign proc (op lookup-variable-value) (const +) (reg env))
;(restore continue)
;(restore env)
;(restore continue)
;(save continue)
;(save proc)
;(save env)
;(save continue)
;(assign val (const 2))
;(restore continue)
;(assign argl (op list) (reg val))
;(restore env)
;(save argl)
;(save continue)
;(assign val (const 1))
;(restore continue)
;(restore argl)
;(assign argl (op cons) (reg val) (reg argl))
;(restore proc)
;(restore continue)
;(test (op primitive-procedure?) (reg proc))
;(branch (label primitive-branch6))
;compiled-branch5
;(assign continue (label after-call4))
;(assign val (op compiled-procedure-entry) (reg proc))
;(goto (reg val))
;primitive-branch6
;(save continue)
;(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;(restore continue)
;after-call4


; That is... a lot of save and restore.
(display-list (statements (compile '(+ 1 (+ 2 3)) 'val 'next)))
