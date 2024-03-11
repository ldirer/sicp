
(define (reverse items) 
  (define (reverse-helper items result)
    (if (null? items)
      result
      (reverse-helper (cdr items) (cons (car items) result))
   ))
  (reverse-helper items (list))
)


(reverse (list 1 4 9 16 25))

