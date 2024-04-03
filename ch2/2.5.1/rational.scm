
(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                (* (numer y) (denom x)))
      (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                (* (numer y) (denom x)))
      (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
      (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
      (* (denom x) (numer y))))
  ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
    (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
    (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
    (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
    (lambda (x y) (tag (div-rat x y))))
  (put 'make 'rational
    (lambda (n d) (tag (make-rat n d))))

  ; ex2.79
  (define (rational-equ? x y)
    (and (= (numer x) (numer y)) (= (denom x) (denom y)))
    )
  (put 'equ? '(rational rational) rational-equ?)
  ; ex2.80
  (define (rational=zero? x)
    (=zero? (numer x))
    )
  (put '=zero? '(rational) rational=zero?)

  ; ex2.83
  (define (raise-rational r) (make-complex-from-real-imag (/ (numer r) (denom r)) 1))
  (put 'raise '(rational) raise-rational)

  ; ex2.88
  ; I'm relying on - 0 .. rather than a call to `negate` because the latter produces an object tagged with `scheme-number`
  ; when make-rat runs it calls gcd, and gcd doesn't know what to do with a 'scheme number'.
  ; if the simplification from ex2.78 was fully implemented (and the tag on 'scheme-number' removed entirely) we could
  ; use negate here I think.
  (define (negate-rat x) (make-rat (- 0 (numer x)) (denom x)))
  (put 'negate '(rational) negate-rat)

  'done
  )

(define (make-rational n d) ((get 'make 'rational) n d))