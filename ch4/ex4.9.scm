(load "ch4/syntax.scm")
(load "ch4/ex4.4.scm")
; while loop
; let's implement a while loop. Syntax as follows:
;(while condition ...body)

; Note the for loop can be built on top of the while loop. Roughly:
; A for loop is made of a few parts: for (initializer; condition; action) body
; Can be written as:
;   initializer
;   while (condition)
;     ...body
;     action



(define (is-while? expr)
  (tagged-list? 'while expr)
  )
(define (while-condition expr) (cadr expr))
(define (while-body expr) (cddr expr))


; the while expression will be translated into:
; condition turned into (condition-func)
; (define while-func lambda () (if (condition-func) (...body (while-func))))
; (while-func)
; to avoid naming conflicts we will create a new scope by wrapping everything in a lambda
; eventually the while loop will evaluate to 'false'. I guess that's ok?
(define (while->combination expr)
  ; return a lambda that we call immediately (hence wrapping 'list')
  (list (make-lambda '()
          (list
            (make-definition 'condition-func (make-lambda '() (list (while-condition expr))))
            (make-definition
              'loop-func
              (make-lambda '()
                (list (make-if
                        (list 'condition-func)
                        (sequence->expr (append (while-body expr) (list (list 'loop-func))))
                        #f
                        )
                  )
                )
              )
            ; initial call
            (list 'loop-func)
            )
          ))
  )


(define (install-while)
  put 'eval 'while (lambda (expr env) (eval (while->combination expr)))
  )

(install-while)


(while->combination '(while (< i 10)
                       (display i)
                       (display "\n")
                       (set! i (+ i 1))
                       ))
; expected: ((lambda () (define condition-func (lambda () (< i 10))) (define loop-func (lambda () (if (condition-func) (begin (display i) (display "\n") (set! i (+ i 1)) (loop-func)) #f))) (loop-func)))
; tested in the real Scheme console, looks ok.




