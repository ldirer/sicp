(load "ch2/2.5.3/ex2.90/term_generics.scm")

(define (zeros n)
  (cond ((= n 0) (list))
    (else cons 0 (zeros (- n 1)))
    )
  )

; Dense term list: a list of coefficients is stored.
; Order of terms is their position in the list (highest first).
(define (install-termlist-dense-package)
  (define (tag x) (attach-tag 'dense x))
  (define (max-order term-list)
    (- (length term-list) 1)
    )

  (define (adjoin-term term term-list)
    ; if term order is not greater than the polynomial order... that should be an error ?
    ; if term order is greater, we need to fill in our list with zeros so it remains 'dense'.
    (if (< (order term) (max-order term-list))
      (error "cannot adjoing a term of order lower than the term list" (list term term-list))
      (append (cons (coeff term) (zeros (- (- (order term) (max-order term-list)) 1))) term-list)
      ))

  (define (the-empty-termlist) '())

  (define (first-term term-list) (make-term (- (length term-list) 1) (car term-list)))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))

  (define (negate-dense term-list)
    (map - term-list)
    )

  (put 'the-empty-termlist 'dense (lambda () (tag (the-empty-termlist))))
  (put 'first-term '(dense) first-term)
  (put 'rest-terms '(dense) (lambda (x) (tag (rest-terms x))))
  (put 'empty-termlist? '(dense) (lambda (x) (null? x)))
  (put 'negate '(dense) (lambda (term-list) (tag (negate-dense term-list))))

  (put 'adjoin-term 'dense (lambda (term term-list) (tag (adjoin-term term term-list))))

  (put 'make 'dense (lambda (term-list) (tag term-list)))
  )

(define (make-termlist-dense terms)
  ((get 'make 'dense) terms)
  )
