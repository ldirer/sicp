(define (install-polynomial-package)
  (load "ch2/2.5.3/ex2.90/termlist_dense.scm")
  (load "ch2/2.5.3/ex2.90/termlist_sparse.scm")
  (install-termlist-sparse-package)
  (install-termlist-dense-package)
  ;; internal procedures
  ;; representation of poly
  (define (make-poly variable term-list) (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))

  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))
  (define (variable? x) (symbol? x))


  ;; add and multi
  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1)
        (add-terms (term-list p1) (term-list p2)))
      (error "Polys not in same var: ADD-POLY" (list p1 p2))))

  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
      ((empty-termlist? L2) L1)
      (else
        (let ((t1 (first-term L1))
               (t2 (first-term L2)))
          (cond ((> (order t1) (order t2))
                  (adjoin-term
                    t1 (add-terms (rest-terms L1) L2)))
            ((< (order t1) (order t2))
              (adjoin-term
                t2 (add-terms L1 (rest-terms L2))))
            (else
              (adjoin-term
                (make-term (order t1)
                  (add (coeff t1) (coeff t2)))
                (add-terms (rest-terms L1)
                  (rest-terms L2))))))))
    )


  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1)
        (mul-terms (term-list p1) (term-list p2)))
      (error "Polys not in same var: MUL-POLY" (list p1 p2))))

  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
      (the-empty-termlist)
      (add-terms (mul-term-by-all-terms (first-term L1) L2)
        (mul-terms (rest-terms L1) L2))))
  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
      (the-empty-termlist)
      (let ((t2 (first-term L)))
        (adjoin-term
          (make-term (+ (order t1) (order t2))
            (mul (coeff t1) (coeff t2)))
          (mul-term-by-all-terms t1 (rest-terms L))))))

  (define (tag p) (attach-tag 'polynomial p))
  (put 'add '(polynomial polynomial)
    (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial)
    (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'make 'polynomial
    (lambda (var terms) (tag (make-poly var terms))))

  ; ex2.87
  (define (=zero-poly? p)
    (empty-termlist? (term-list p))
    )

  (put '=zero? '(polynomial) =zero-poly?)

  ; ex2.88
  ; note the key to make this work is to define negate as a generic operation (on other data types).
  ; this is what makes the 'recursive call' eventually terminate.
  ; ex2.90 interestingly, the solution I wrote for ex2.88 doesn't work with ex2.90 (2 representations for term list).
  ; The way `map` is used here assumes `term-list` is a list of terms. But it shouldn't have to assume anything about the structure of `term-list`.
  ; (make-poly (variable p) (map (lambda (term) (make-term (order term) (negate (coeff term)))) (term-list p)))
  (define (negate-poly p)
    (make-poly (variable p) (negate (term-list p)))
    )

  (put 'negate '(polynomial) (lambda (p) (tag (negate-poly p))))

  ; now we can define subtraction easily
  (define (sub-poly p1 p2) (add-poly p1 (negate-poly p2)))
  (put 'sub '(polynomial polynomial) (lambda (p1 p2) (tag (sub-poly p1 p2))))

  'done)

(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))


(define (make-polynomial-sparse var terms)
  (
    make-polynomial var (make-termlist-sparse terms)
    ))
(define (make-polynomial-dense var terms)
  (
    make-polynomial var (make-termlist-dense terms)
    ))
