
(define (install-scheme-number-package)
  (define (tag x) (attach-tag 'scheme-number x))
  (put 'add '(scheme-number scheme-number)
    (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number)
    (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number)
    (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
    (lambda (x y) (tag (/ x y))))
  (put 'make 'scheme-number (lambda (x) (tag x)))


  ; ex2.79
  (define (number-equ? x y) (= x y))
  (put 'equ? '(scheme-number scheme-number) number-equ?)

  ; ex2.80
  (define (=zero-num? x)
    (= 0 x)
    )
  (put '=zero? '(scheme-number) =zero-num?)

  ; ex2.83
  (define (raise-integer n) (make-rational n 1))
  (put 'raise '(scheme-number) raise-integer)

  ; ex2.88
  (define (negate x) (sub 0 x))
  (put 'negate '(scheme-number) negate)

  'done
  )


(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))