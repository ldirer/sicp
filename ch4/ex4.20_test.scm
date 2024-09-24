(load "ch4/ex4.20.scm")
(load "testing.scm")

(define test-expr '(letrec ((a 1) (b (+ a 1))) (* a b)))

(check-equal
  "letrec conversion to let"
  (letrec->let test-expr)
  '(let ((a '*unassigned*) (b '*unassigned*)) (set! a 1) (set! b (+ a 1)) (* a b))
  )


;(define (f x)
;  (letrec
;    ((even? (lambda (n)
;              (if (= n 0) true
;                          (odd?
;                            (odd?
;                              (- n 1)))))
;       (lambda (n)
;         (if (= n 0) false (even? (- n 1))))))
;    ;⟨rest of body of f⟩
;    ))
