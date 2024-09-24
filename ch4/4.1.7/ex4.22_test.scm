(load "testing.scm")
(load "ch4/4.1.7/eval.scm")
(load "ch4/4.1.4/evaluator.scm")


(define env (extend-environment (list '+) (list (list 'primitive +)) the-empty-environment))
(lookup-variable-value '+ env)
(check-equal "can eval let expressions" (eval '(let (
              (a 1)
              (b 2)
              )
         (+ a b)
         ) env) 3)