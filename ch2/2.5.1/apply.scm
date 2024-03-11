
(define (attach-tag type-tag contents) (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
    (car datum)
    (error "Bad tagged datum: TYPE-TAG" datum))
  )
(define (contents datum)
  (if (pair? datum)
    (cdr datum)
    (error "Bad tagged datum: CONTENTS" datum))
  )

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
        (apply proc (map contents args))
        (error "No method for these types: APPLY-GENERIC"
          (list op type-tags)))))
  )


; personal implementation of get and put.
; made one change compared with what I used in ex2.73: `get` returns false instead of an error when a lookup fails.
; this makes it compatible with apply-generic (which in turn handles errors).
(define op-table (list))

(define (put op type proc)
  (set! op-table (cons (list op type proc) op-table)))

(define (get op type)

  (define (lookup op-list op type)
    (cond
      ((null? op-list) false)
      ((and (equal? op (caar op-list)) (equal? type (cadar op-list))) (caddar op-list))
      (else (lookup (cdr op-list) op type))
      )
    )
  (lookup op-table op type)
  )



