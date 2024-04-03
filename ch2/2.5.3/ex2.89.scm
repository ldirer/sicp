; term-list representation for dense polynomials

; everything is the same as for sparse polynomials except 'adjoin-term'.
;; representation of terms and term lists
(define (adjoin-term term term-list)
    (cons term term-list))

(define (the-empty-termlist) '())
(define (first-term term-list) (car term-list))
(define (rest-terms term-list) (cdr term-list))
(define (empty-termlist? term-list) (null? term-list))
(define (make-term order coeff) (list order coeff))
(define (order term) (car term))
(define (coeff term) (cadr term))


