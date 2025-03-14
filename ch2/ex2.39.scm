;(define (reverse sequence)
;  (fold-right (lambda (x y) ) (list) sequence)
;)
(define (reverse sequence)
  (fold-right (lambda (x acc) (append acc (list x))) (list) sequence)
  )

(reverse (list 1 2 3))
; expected:( 3 2 1)

(define (reverse sequence)
  (fold-left (lambda (acc x) (cons x acc)) (list) sequence)
  )

(reverse (list 1 2 3))
; expected:( 3 2 1)
