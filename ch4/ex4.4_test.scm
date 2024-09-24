(load "ch4/ex4.4.scm")

(define env '("placeholder"))
; true and false don't work at this stage because they are variables.
; we can use the literals though
(eval-and '(and #t #f) env) ; expected: false
(eval-and '(and "true" "yes") env) ; expected: "yes"
(eval-and '(and) env) ; expected: true


(eval-or '(or #f #f "this" #f) env) ; expected: "this"
(eval-or '(or #f) env) ; expected: false
(eval-or '(or "this" "that") env) ; expected: "this"
(eval-or '(or) env) ; expected: false



(display "Syntax translation tests")

;sanity check:
(eval (make-if "uh" "then" "else") env); expected: then
;sanity check:
(eval (make-if #t #t "else") env); expected: else
;(and->if '(and "this" "that" "thus"))
;expected: (if this (if that (if thus thus #f) #f) #f)

(check-equal "eval translated 'and'" (eval (and->if '(and "this" "that" "thus")) env) "thus")
(check-equal "eval translated empty 'and'" (eval (and->if '(and)) env) true)

(check-equal "eval translated 'or'" (eval (or->if '(or #f "truthy" #f)) env) "truthy")
(check-equal "eval translated empty 'or'" (eval (or->if '(or)) env) #f)
