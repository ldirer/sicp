; this isn't really a 'generics' package: there is only one implementation.
; packages that load this don't have to know how many representations of 'term' exist though.
(define (make-term order coeff) (list order coeff))
(define (order term) (car term))
(define (coeff term) (cadr term))
