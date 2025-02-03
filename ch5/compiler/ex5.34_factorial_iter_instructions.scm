(assign val (op make-compiled-procedure) (label entry2) (reg env))
(goto (label after-lambda1))
entry2
(assign env (op compiled-procedure env) (reg proc))
(assign env (op extend-environment) (const (n)) (reg argl) (reg env))
; this is the iter compiled procedure
(assign val (op make-compiled-procedure) (label entry7) (reg env))
(goto (label after-lambda6))
entry7                                                                                  ; iter body
(assign env (op compiled-procedure env) (reg proc))
(assign env (op extend-environment) (const (product n)) (reg argl) (reg env))
; save continue and env before applying > because the if-alternate branch uses them
(save continue)
(save env)
(assign proc (op lookup-variable-value) (const >) (reg env))
(assign val (op lookup-variable-value) (const n) (reg env))
(assign argl (op list) (reg val))
(assign val (op lookup-variable-value) (const counter) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch22))
compiled-branch21
(assign continue (label after-call20))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
primitive-branch22
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
after-call20
(restore env)
(restore continue)
(test (op false?) (reg val))
(branch (label false-branch9))
true-branch10
(assign val (op lookup-variable-value) (const product) (reg env))
(goto (reg continue))                                                                   ; iter termination
false-branch9
; recursive call to iter
(assign proc (op lookup-variable-value) (const iter) (reg env))
; note this (save continue) is just for the '+' call.
(save continue)
(save proc)
(save env)
(assign proc (op lookup-variable-value) (const +) (reg env))
(assign val (const 1))
(assign argl (op list) (reg val))
(assign val (op lookup-variable-value) (const counter) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch16))
compiled-branch15
(assign continue (label after-call14))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
primitive-branch16
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
after-call14
(assign argl (op list) (reg val))
(restore env)
(save argl)
(assign proc (op lookup-variable-value) (const *) (reg env))
(assign val (op lookup-variable-value) (const product) (reg env))
(assign argl (op list) (reg val))
(assign val (op lookup-variable-value) (const counter) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch13))
compiled-branch12
(assign continue (label after-call11))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
primitive-branch13
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
after-call11
(restore argl)
(assign argl (op cons) (reg val) (reg argl))                                ; done with the arguments of the iter recursive call
(restore proc)
(restore continue)
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch19))
compiled-branch18
(assign val (op compiled-procedure-entry) (reg proc))
; This is the part that makes tail recursion happen. We go to the procedure without saving continue.
; The alternative would be to (save continue), and inside the compiled procedure body (goto (label after-procedure-xx)) where we would (restore continue) (goto (reg continue))
; Continue values would accumulate on the stack with every recursive call. Here we transfer control to the compiled procedure (iter, again) without adding to the stack.
(goto (reg val))
primitive-branch19
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
(goto (reg continue))
after-call17
after-if8
after-lambda6                                                           ; after-iter-definition
(perform (op define-variable!) (const iter) (reg val) (reg env))
(assign val (const ok))
; (iter 1 1) call
(assign proc (op lookup-variable-value) (const iter) (reg env))
(assign val (const 1))
(assign argl (op list) (reg val))
(assign val (const 1))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch5))
compiled-branch4
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
primitive-branch5
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
(goto (reg continue))
after-call3
after-lambda1
(perform (op define-variable!) (const factorial) (reg val) (reg env))
(assign val (const ok))
