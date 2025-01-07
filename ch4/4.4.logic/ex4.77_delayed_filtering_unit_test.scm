(load "testing.scm")
(load "ch4/4.4.logic/ex4.77_delayed_filtering.scm")
(load "ch4/4.4.logic/syntax.scm")
(load "ch4/4.4.logic/frames.scm")

(check-equal "unbound-vars"
  (unbound-vars (query-syntax-process '(job ?who ?what ?how)) (list (make-binding '(? who) 'them)))
  (list '(? what) '(? how))
  )
(check-equal "unbound-vars with variables referencing other variables"
  (unbound-vars (query-syntax-process '(job ?who ?what ?how)) (list (make-binding '(? who) '(? what))))
  (list '(? who) '(? what) '(? how))
  )
