(define (inc x) (+ x 1))
(define (double f) (define (result x) (f (f x))) result)


(((double (double double)) inc) 5)
; 21
