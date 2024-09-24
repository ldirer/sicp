; adding a new letrec syntax
;(define (f x)
;  (letrec
;    ((even? (lambda (n)
;              (if (= n 0) true
;                          (odd?
;                            (odd?
;                              (- n 1)))))
;       (lambda (n)
;         (if (= n 0) false (even? (- n 1))))))
;    ⟨rest of body of f ⟩))



;letrec expressions, which have the form
;(letrec ((⟨var1 ⟩ ⟨exp1 ⟩) . . . (⟨varn ⟩ ⟨expn ⟩))
;⟨body⟩)
;are a variation on let in which the expressions ⟨expk ⟩ that
;provide the initial values for the variables ⟨var k ⟩ are eval-
;uated in an environment that includes all the letrec bind-
;ings. is permits recursion in the bindings, such as the
;mutual recursion of even? and odd? in the example above

(load "ch4/ex4.16.scm")

(define (letrec->let expr)
  (define bindings (letrec-bindings expr))
  (define body (letrec-body expr))

  (define binding-names (map letrec-binding-name bindings))
  (define binding-values (map letrec-binding-value bindings))

  (define let-bindings (map (lambda (binding) (make-let-binding (letrec-binding-name binding) ''*unassigned*)) bindings))
  (define assignments (map (lambda (binding) (make-assignment (letrec-binding-name binding) (letrec-binding-value binding))) bindings))

  (make-let let-bindings (append assignments body))
  )


; b.
; > Louis Reasoner is confused about internal definitions. The way he sees it, if you don't like
; > to use define inside a procedure, you can just use let. Illustrate what is loose about his reasoning
; > by drawing an environment diagram that shows the environment in which the "rest of body of f" is
; > evaluated during the evaluation of the expression `(f 5)`.
; > Draw an environment diagram for the same evaluation, but with let in place of letrec in the definition of f.


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
;

; I think the key difference is that with let we get nested environments, when with
; letrec all variables are defined in the same environment (truly 'simultaneous' definitions).




