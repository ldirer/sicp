(load "testing.scm")
(load "ch5/machine.scm")
(load "ch5/ex5.21_a.scm")

(define machine (make-machine
                  '(tree
                    ; temp
                     val
                     continue)
                  (list
                    (list 'car car)
                    (list 'cdr cdr)
                    (list 'null? null?)
                    (list 'pair? pair?)
                    (list 'not not)
                    (list '+ +)
                    )
                  count-leaves-controller))


(define tree (list (list 1 2) (list 3 4)))
(set-register-contents! machine 'tree tree)

(start machine)
(check-equal "simple count leaves" (get-register-contents machine 'val) 4)

(define tree (list (list 1 (list 2 3)) (list (list 4 5 (list 6 7)) 8)))
(set-register-contents! machine 'tree tree)

(start machine)
(check-equal "nested count leaves" (get-register-contents machine 'val) 8)


(set-register-contents! machine 'tree (list))

(start machine)
(check-equal "count leaves empty tree" (get-register-contents machine 'val) 0)
