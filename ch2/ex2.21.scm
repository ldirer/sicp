(define (square x) (* x x))



(define (square-list items)
  (if (null? items) 
    (list) 
    (cons (square (car items)) (square-list (cdr items))))
  )


(square-list (list 5 2 3 4))


(define (square-list items)
  (map square items)
  )

(square-list (list 1 2 3 4))


