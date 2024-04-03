; modifying `apply-generic` with a strategy to coerce multiple arguments
(load "ch2/2.5.2/apply.scm")

(define (zip a b)
  (define (iter a b result)
    (cond
      ((null? a) (reverse result))
      ((null? b) (reverse result))
      (else (iter (cdr a) (cdr b) (cons (list (car a) (car b)) result)))
      )
    )

  (iter a b '())
  )

(zip (list 1 2 3) (list 'a 'b 'c))
;expected: ((1 a) (2 b) (3 c))

(define (get-coercion-or-identity t1 t2)
  (if (equal? t1 t2)
    (lambda (x) x)
    (get-coercion t1 t2)
    )
  )

; can't use `(apply and conds)`, and is a special form and not a regular function.
(define (and-list conds)
  (cond
    ((null? conds) true)
    ((car conds) (and-list (cdr conds)))
    (else false))
  )

; map over types
; take first one.
; look for function to convert type for each thing.
; if one is missing, start again taking the second argument type as 'reference'
(define (search-type-target type-tags)

  (define (iter type-target type-tags types-to-try)
    (begin (display "iter type-target: ")
           (display type-target)
           (display "\n")
      )
    (cond
      ; order matters,
      ((and-list (map (lambda (t) (get-coercion-or-identity type-target t)) type-tags)) type-target)
      ((null? types-to-try) false)
      (else (iter (car types-to-try) type-tags (cdr types-to-try)))
      )
    )

  (iter (car type-tags) type-tags (cdr type-tags))
  )

(define (no-method stuff) (error "no method for these types: " stuff))

(define (apply-generic op . args)

  ; need this inner function to avoid an infinite loop
  (define (apply-generic-with-coercion op attempt-coerce? args)
    (let ((type-tags (map type-tag args)))
      (let ((proc (get op type-tags)))
        (if proc
          (apply proc (map contents args))
          (if (and (>= (length args) 2) attempt-coerce?)
            (let ((type-target (search-type-target type-tags)))
              (if (not type-target)
                (no-method (list op type-tags "no type target found"))
                ; we could avoid getting coercion functions twice...
                (let ((coercion-functions (map (lambda (t) (get-coercion-or-identity type-target t)) type-tags)))
                  (apply-generic-with-coercion op false (map (lambda (pair) ((car pair) (cadr pair))) (zip coercion-functions args)))
                  )
                )
              )
            (no-method (list op type-tags "no and args length > 2 and attempt coerce")))))
      )
    )

  (apply-generic-with-coercion op true args)
  )


; testing by defining generic operations with the new method

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


(define (scheme-number->complex n)
  (make-complex-from-real-imag (contents n) 0)
  )
(put-coercion 'complex 'scheme-number scheme-number->complex)

;coercion-table


(add (make-complex-from-real-imag 1 1) (make-complex-from-real-imag 1 1))
;Value: (complex rectangular 2 . 2)

(add (make-rational 1 2) (make-rational 1 2))
;Value: (complex rectangular 2 . 2)

(add (make-scheme-number 1) (make-scheme-number 2))
;Value: (scheme-number . 3)

(get 'add (list 'scheme-number 'complex))
; expected: false



(search-type-target (list 'scheme-number 'complex))
;expected: complex
(search-type-target (list 'complex 'scheme-number))
;expected: complex

; finally this seems to be working
(add (make-scheme-number 1) (make-complex-from-real-imag 1 1))
;Value: (complex rectangular 2 . 1)
(add (make-complex-from-real-imag 1 1) (make-scheme-number 1) )
;Value: (complex rectangular 2 . 1)
