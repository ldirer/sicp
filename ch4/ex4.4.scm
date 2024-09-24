(load "ch4/syntax.scm")
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


(define (or->if expr)
  (cond
    ((null? (cdr expr)) '#f)
    ((null? (cddr expr)) (make-if (cadr expr) (cadr expr) '#f))
    ; we recurse on `cdr expr` because the first term will be ignored.
    (else (make-if (cadr expr) (cadr expr) (or->if (cdr expr))))
    )
  )


; with syntax translation we could write
(define (eval-and expr env)
  eval (and->if expr) env
  )
(define (eval-or expr env)
  eval (or->if expr) env
  )
