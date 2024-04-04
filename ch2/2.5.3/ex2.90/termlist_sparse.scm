(load "testing.scm")

;; representation of terms and term lists
(define (adjoin-term term term-list)
  (if (=zero? (coeff term))
    term-list
    (cons term term-list)))
(define (the-empty-termlist) '())
(define (first-term term-list) (car term-list))
(define (rest-terms term-list) (cdr term-list))
(define (empty-termlist? term-list) (null? term-list))
(define (make-term order coeff) (list order coeff))
(define (order term) (car term))
(define (coeff term) (cadr term))

; x**100 + 2x**2 + 1
(check-equal
  "first term"
  (first-term (list (list 100 1) (list 2 2) (list 0 1)))
  (list 100 1)
  )
