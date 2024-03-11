
(define (same-parity n . others)
  (let ((test? (if (even? n) even? odd?)))
  (define (iter items result)
  (cond 
    ((null? items) (reverse result))
    ((test? (car items)) (iter (cdr items) (cons (car items) result)))
    (else (iter (cdr items) result))
))
  (cons n (iter others (list)))
)
)


(same-parity 1 3 4 5 6 7)


