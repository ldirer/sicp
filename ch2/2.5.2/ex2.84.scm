(load "ch2/2.5.2/generic.scm")


(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
        (apply proc (map contents args))
        (if (= (length args) 2)
          (let ((type1 (car type-tags))
                 (type2 (cadr type-tags))
                 (a1 (car args))
                 (a2 (cadr args)))

            (if (equal? type1 type2)
              ; avoid coercion if arguments are the same type (ex2.81)
              (error "No method for " (list op type-tags))
              ; rather than trying to predict which of a1 and a2 has the 'higher type', we try to convert both.
              (let ((a1-raised (raise-into a1 a2))
                     (a2-raised (raise-into a2 a1)))
                (cond
                  (a1-raised (apply-generic op a1-raised a2))
                  (a2-raised (apply-generic op a1 a2-raised))
                  (else (error "No method for these types 1"
                          (list op type-tags)))
                  )
                )
              )
            )
          (error "No method for these types 2"
            (list op type-tags))))))
  )

;i think this could just be `memq`
(define (in-list val vals)
  (if (null? vals)
    false
    (or (equal? val (car vals)) (in-list val (cdr vals)))
    )
  )

; (recursively) raise a1 into type of a2
; return false if not possible
; inspired by
;https://eli.thegreenplace.net/2007/09/16/sicp-section-252
(define (raise-into a1 a2)
  (let ((t1 (type-tag a1))
         (t2 (type-tag a2)))
    (cond
      ((equal? t1 t2) a1)
      ((get 'raise (list t1)) (raise-into (raise a1) a2))
      (else false)
      )
    )
  )

; testing utilities
(in-list 'scheme-number (list 'scheme-number 'rational))

; expected: true
(equal? 'scheme-number (car (list 'scheme-number 'rational)))

; testing again by redefining things

;generic arithmetic
(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (raise obj) (apply-generic 'raise obj))

(load "ch2/2.5.1/complex.scm")
(load "ch2/2.5.1/rational.scm")
(load "ch2/2.5.1/scheme-number.scm")
(install-complex-package)
(install-rational-package)
(install-scheme-number-package)


(define a (make-scheme-number 1))
(define b (make-complex-from-real-imag 1 1))

; debugging
;(raise-into a (make-rational 2 1))
;(add (raise (raise a)) b)

(add a b)
;Value: (complex rectangular 2 . 1)
(add b a)
;Value: (complex rectangular 2 . 1)


; if new types are added to the 'tower of types' things should still work.
; if they don't implement raise we won't attempt to raise them, and 'apply-generic' might fail to find a procedure (which is the behavior we expect).