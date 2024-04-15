(load "ch2/2.5.3/ex2.90/term_generics.scm")
(load "testing.scm")

(define (install-termlist-sparse-package)
  ;; representation of terms and term lists
  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
      term-list
      (cons term term-list)))
  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))

  (define (negate-sparse term-list)
    (map (lambda (term) (make-term (order term) (negate (coeff term)))) term-list)
    )

  (define (tag x) (attach-tag 'sparse x))
  (put 'the-empty-termlist 'sparse (lambda () (tag (the-empty-termlist))))
  (put 'first-term '(sparse) first-term)
  (put 'rest-terms '(sparse) (lambda (x) (tag (rest-terms x))))
  (put 'empty-termlist? '(sparse) (lambda (x) (null? x)))

  (put 'negate '(sparse) (lambda (term-list) (tag (negate-sparse term-list))))

  (put 'adjoin-term 'sparse (lambda (term term-list) (tag (adjoin-term term term-list))))

  (put 'make 'sparse (lambda (term-list) (tag term-list)))
  )

(define (make-termlist-sparse terms)
  ((get 'make 'sparse) terms)
  )

