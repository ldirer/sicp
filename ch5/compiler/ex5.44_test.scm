(load "ch5/compiler/compile_and_run.scm")
(load "ch5/compiler/utils.scm")
(load "testing.scm")

; reproducing the issue mentioned in the book
; not doing matrices because idk how to represent these

(define program '(begin
     (define (f + * a b x y)
       (+ (* a x) (* b y))
       )

     (define (*str s n)
       (cond
         ((= n 0) "")
         (else (string-append s (*str s (- n 1))))
         )
       )

     (define +str string-append)

     (f +str *str "oh " "ah " 3 2)
     )
  )

;(display-list (statements (compile program 'val 'next the-empty-compiler-environment)))
(define result (compile-and-run program))
(check-equal "correctly interpreted + and * as variables" result "oh oh oh ah ah ")
