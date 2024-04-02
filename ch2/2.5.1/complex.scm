(load "ch2/2.5.1/apply.scm")

(load "ch2/2.5.1/complex-polar.scm")
(load "ch2/2.5.1/complex-rectangular.scm")

(define (install-complex-package)
  (install-polar-package)
  (install-rectangular-package)

  ;; imported procedures from rectangular and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
      (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
      (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
      (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
      (- (angle z1) (angle z2))))
  ;; interface to rest of the system
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
    (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
    (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
    (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
    (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'make-from-real-imag 'complex
    (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
    (lambda (r a) (tag (make-from-mag-ang r a))))

  ; added as part of ex2.77
  ; I think the `(define (real-part ...` were just flat out missing.
  ; It only looked like it worked because there are `real-part`, `imag-part` loaded by default in my Scheme implementation.
  ; I think these should be defined at the top of the package for clarity, not moving to preserve book/thought order.
  (define (real-part z) (apply-generic 'real-part z))
  (define (imag-part z) (apply-generic 'imag-part z))
  (define (magnitude z) (apply-generic 'magnitude z))
  (define (angle z) (apply-generic 'angle z))


  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'magnitude '(complex) magnitude)
  (put 'angle '(complex) angle)

  ; ex2.79
  (define (complex-equ? z1 z2)
    (and (= (real-part z1) (real-part z2)) (= (imag-part z1) (imag-part z2)))
    )
  (put 'equ? '(complex complex) complex-equ?)
  ; ex2.80
  (define (=zero? z)
    (and (= (real-part z) 0) (= (imag-part z) 0))
    )
  (put '=zero? '(complex) =zero?)

  'done
  )

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y)
  )
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a)
  )
