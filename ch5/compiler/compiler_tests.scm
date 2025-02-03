(load "testing.scm")
(load "ch5/compiler/compiler.scm")

(check-equal "next linkage" (compile '5 'val 'next) (list '() '(val) '((assign val (const 5)))))

(check-equal "return linkage" (compile '5 'val 'return) (list '(continue) '(val) '((assign val (const 5)) (goto (reg continue)))))


(check-equal "append empty instruction sequences" (append-instruction-sequences (empty-instruction-sequence) (empty-instruction-sequence)) (empty-instruction-sequence))


(compile '(+ 1 1) 'val 'next)
