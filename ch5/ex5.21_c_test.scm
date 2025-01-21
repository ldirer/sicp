;testing code from https://www.inchmeal.io/sicp/ch-5/ex-5.21.html
(load "testing.scm")
(load "ch5/machine.scm")
(load "ch5/ex5.21_b.scm")

(define count-leaves-iter-machine
  (make-machine
   '(tree count continue temp)
   (list (list 'null? null?)
		   (list 'pair? pair?)
		   (list 'car car)
		   (list 'cdr cdr)
		   (list 'not not)
		   (list '+ +))
   '((assign continue (label done))
	 (assign count (const 0))
	loop
	 (test (op null?) (reg tree))
	 (branch (label base-case-0))
	 (assign temp (op pair?) (reg tree))
	 (test (op not) (reg temp))
	 (branch (label base-case-1))
	 (save continue)
	 (save tree)
	 (assign tree (op cdr) (reg tree))
	 (assign continue (label car-count))
	 (goto (label loop))
	car-count
	 (restore tree)
	 (restore continue)
	 (assign tree (op car) (reg tree))
	 (goto (label loop))
	base-case-0
	 (goto (reg continue))
	base-case-1
	 (assign count (op +) (reg count) (const 1))
	 (goto (reg continue))
	done)))



(define t '((1 . (2 . 3)) . ((4 . 5) . ((6 . ()) . 7))))

(set-register-contents! count-leaves-iter-machine 'tree t)

(start count-leaves-iter-machine)

(check-equal "inchmeal code" (get-register-contents count-leaves-iter-machine 'count) 7)

