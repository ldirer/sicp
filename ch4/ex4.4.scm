(load "ch4/syntax.scm")
(load "ch4/interpreter.scm")
(load "ch4/ex4.3.scm")

(define (eval-and expr env)
  (eval-and-exprs (cdr expr) env true)
  )

(define (eval-and-exprs exprs env previous-value)
  (cond ((null? exprs) previous-value)
    (else
      (let ((first-value (eval (car exprs) env)))
        (if (false? first-value)
          false
          (eval-and-exprs (cdr exprs) env first-value)
          )
        )
      )
    )
  )

(define env '("placeholder"))
; true and false don't work at this stage because they are variables.
; we can use the literals though
(eval-and '(and #t #f) env) ; expected: false
(eval-and '(and "true" "yes") env) ; expected: "yes"
(eval-and '(and) env) ; expected: true


(define (eval-or expr env)
  (eval-or-exprs (cdr expr) env)
  )

(define (eval-or-exprs exprs env)
  (cond ((null? exprs) false)
    (else
      (let ((first-value (eval (car exprs) env)))
        (if (true? first-value)
          first-value
          (eval-or-exprs (cdr exprs) env)
          )
        )
      )
    )
  )

(eval-or '(or #f #f "this" #f) env) ; expected: "this"
(eval-or '(or #f) env) ; expected: false
(eval-or '(or "this" "that") env) ; expected: "this"
(eval-or '(or) env) ; expected: false

(define (install-and-or)
  (put 'eval 'and eval-and)
  (put 'eval 'or eval-or)
  )


(install-and-or)


; now as derived forms. `and a b c` can be seen as `if a then a else if b then b else..`


(define (and->if expr)
  (cond
    ((null? (cdr expr)) '#t)
    ; return the last value if all truthy
    ((null? (cddr expr)) (make-if (cadr expr) (cadr expr) '#f))
    ; we recurse on `cdr expr` because the first term will be ignored.
    (else (make-if (cadr expr) (and->if (cdr expr)) '#f))
    )
  )

;sanity check:
(eval (make-if "uh" "then" "else") env); expected: then
;sanity check:
(eval (make-if #t #t "else") env); expected: else
;(and->if '(and "this" "that" "thus"))
;expected: (if this (if that (if thus thus #f) #f) #f)

(check-equal "eval translated 'and'" (eval (and->if '(and "this" "that" "thus")) env) "thus")
(check-equal "eval translated empty 'and'" (eval (and->if '(and)) env) true)


(define (or->if expr)
  (cond
    ((null? (cdr expr)) '#f)
    ((null? (cddr expr)) (make-if (cadr expr) (cadr expr) '#f))
    ; we recurse on `cdr expr` because the first term will be ignored.
    (else (make-if (cadr expr) (cadr expr) (or->if (cdr expr))))
    )
  )
(check-equal "eval translated 'or'" (eval (or->if '(or #f "truthy" #f)) env) "truthy")
(check-equal "eval translated empty 'or'" (eval (or->if '(or)) env) #f)


; with syntax translation we could write
(define (eval-and expr env)
  eval (and->if expr) env
  )
(define (eval-or expr env)
  eval (or->if expr) env
  )
