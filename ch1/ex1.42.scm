(define (square x) (* x x))
(define (inc x) (+ x 1))

(define (compose f g) (define (result x) (f (g x))) result)

((compose square inc) 6)
; 49
