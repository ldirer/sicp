(load "testing.scm")
(load "ch5/compiler.scm")

(compile '5 'val 'next)
; expected: '(assign val (const 5))

(compile '5 'val 'return)
; expected: '((assign val (const 5)) (goto (reg continue)))
