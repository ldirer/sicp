(load "ch4/syntax.scm")

(define (make-lambda-definition name parameters body)
  (make-definition name (make-lambda parameters body))
  )
; straight from https://mk12.github.io/sicp/exercise/4/1.html#4.1.2
; a bit simpler in its approach, and the resulting code is a bit easier to read I think.
(define (while-test exp) (cadr exp))
(define (while-actions exp) (cddr exp))

(define (while->combination exp)
  (list (make-lambda
         '(test body)
         (list (make-lambda-definition
                'loop
                '()
                (list (make-if '(test)
                               (make-begin (list '(body) '(loop)))
                               #f)))
               '(loop)))
        (make-lambda '() (list (while-test exp)))
        (make-lambda '() (while-actions exp))))


(while->combination '(while (< i 10)
                   (display i)
                   (display "\n")
                   (set! i (+ i 1))
                   ))
;Value: ((lambda (test body) (define loop (lambda () (if (test) (begin (body) (loop)) #f))) (loop)) (lambda () (< i 10)) (lambda () (display i) (display "\n") (set! i (+ i 1))))

