(load "ch4/interpreter.scm")
(load "ch4/syntax.scm")
(load "testing.scm")
; example from the book (evaluates to 2 in console):
;(cond ((assoc 'b '((a 1) (b 2))) => cadr)
;  (else false))

; TODO: test this once functions can be applied :)

; Using syntax translation, we would want to generate something like:
;
;   let evaluated-predicate=(cond-predicate clause)
;   if evaluated-predicate then lambda xx (evaluated-predicate)
;
; At this stage we do not have variables though, so we wouldn't be able to test that.
; I thought it would be better with direct evaluation. But we still can't run it fully,
; we need 'apply' which is only partially implemented at this stage.

(define (eval-cond expr env)
  (eval-cond-clauses (cond-clauses expr) env)
  )
(define (eval-cond-clauses clauses env)
  (if (null? clauses)
    #f    ; no else clause
    (let (
           (clause (car clauses))
           (rest (cdr clauses))
           )
      (if (cond-else-clause? clause)
        (if (null? rest)
          (eval (sequence->expr (cond-actions clause)) env)
          (error "ELSE clause isn't last -- COND->IF" clauses)
          )
        (let ((predicate-value (eval (cond-predicate clause) env)))
          (if (true? predicate-value)
            (if (cond-arrow-clause? clause)
              (let ((recipient-proc (eval (cond-arrow-recipient clause) env)))
                (apply recipient-proc (list predicate-value))
                )
              ; non-arrow clause
              (eval (sequence->expr (cond-actions clause)) env)
              )
            ; predicate not truthy, move on to the next
            (eval-cond-clauses rest env)
            )

          )
        )
      )
    )
  )



(define env '())

(cond->if '(cond (#f "ok") (else "nok")))
(check-equal "sanity check cond without arrow - expanding" (eval (cond->if '(cond (#f "no") (else "yes"))) env) "yes")

(check-equal "direct evaluation: cond else" (eval-cond '(cond (else "yes")) env) "yes")
(check-equal "direct evaluation: cond without arrow " (eval-cond '(cond (#f "no") (else "yes")) env) "yes")
(check-equal
  "direct evaluation: cond with arrow"
  (eval-cond '(cond ((1 2) => cadr) (else "uh uh")) env)
  2)


