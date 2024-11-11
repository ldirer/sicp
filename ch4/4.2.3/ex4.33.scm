;(load "ch4/4.2.3/lazylist.scm")
(load "ch4/4.2.2/lazy.scm")


;(define (quote lst)
;  (cons (original-car lst) )
;  )

; this does not work out of the box because our `car` works with a different list representation.
;(car '(a b c))
; I think we would like the above to be equivalent to:
;(car (cons 'a (cons 'b (cons 'c nil))))
;'(1 2 3)
;
;'(a b c)

; WE WANT
; - a quoted list should be evaluated as a list
; - we can do it by transforming the syntax from '(a b c) to (cons 'a (cons 'b ...).
; - Then what our interpreter will receive will be '(cons 'a (cons 'b ... and we will get the expected result
; - reminder that entering '(a b c) means our interpreter receives ''(a b c)


(define nil '())
; the text of quotation is a list of symbols
(define expr ''(a b c))
(quoted? expr)
(text-of-quotation expr)


;(define old-quote quote)

;(define (work-quoted-expr quoted-text)
;  (cond
;    ((not (pair? quoted-text)) (list 'old-quote quoted-text))
;    ((null? quoted-text) (list 'old-quote nil))
;    ; mixing native cons (running on the interpreter side) with cons that will be evaluated by our custom interpreter (with cons a custom bound procedure).
;    ; do we need to quote (car quoted-text) here? I guess... yes? If that's going to be the new-style cons then to be consistent we need the extra quote.
;    ; we need old-quote because our interpreter would recurse indefinitely converting expressions otherwise
;    (else (cons (list 'old-quote 'cons)
;            (cons
;              (car quoted-text)
;              (work-quoted-expr (cdr quoted-text))
;              )
;            )
;      )
;    )
;  )

(define (work-quoted-expr quoted-text)
  (cond
    ((not (pair? quoted-text)) (list 'dumb-quote quoted-text))
;    TODO check that this 'cons will trigger another call to work-quoted-expr. We might as well use old-quote straight away
    ; I think I am still confused about this.
    ; quoted-text is already quoted. 'cons is because we want "cons" as quoted text.
    (else (list 'cons (work-quoted-expr (car quoted-text)) (work-quoted-expr (cdr quoted-text)))
      )
    )
  )

(define (quoted->lazy x)
  (cond ((pair? x) (list 'cons (quoted->lazy (car x)) (quoted->lazy (cdr x))))
        ;; Note: We can't simply move the `eval` call inside `quoted->lazy` and
        ;; then omit it in this branch, since we might have recursed into a cons
        ;; structure. We need this "dumb-quote" escape hatch.
        (else (list 'dumb-quote x))))

(work-quoted-expr '('a 'b 'c))
(work-quoted-expr '(a b c))
(quoted->lazy '(a b c))

(define (eval-quoted expr env)
  (eval (work-quoted-expr (text-of-quotation expr)) env)
  )

(define (old-quoted? expr) (tagged-list? expr 'old-quote))

; eval/apply
(define (eval expr env)
  (cond
    ((self-evaluating? expr) expr)
    ((variable? expr) (lookup-variable-value expr env))
    ((old-quoted? expr) (text-of-quotation expr))
    ((quoted? expr) (eval-quoted expr env))
    ((assignment? expr) (eval-assignment expr env))
    ((definition? expr) (eval-definition expr env))
    ((let? expr) (eval-let expr env))
    ((letrec? expr) (eval-letrec expr env))
    ((if? expr) (eval-if expr env))
    ((lambda? expr) (make-procedure (lambda-parameters expr) (lambda-body expr) env))
    ((begin? expr) (eval-sequence (begin-actions expr) env))
    ((cond? expr) (eval (cond->if expr) env))
    ((application? expr)
      (begin
        (apply
          (actual-value (operator expr) env)
          (operands expr)
          env
          )
        ))
    (else (error "Unknown expression type -- EVAL" expr))
    )
  )

; TODO it's hard to test this rn
; I want to run a repl with this version of eval

