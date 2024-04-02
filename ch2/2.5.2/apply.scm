(define (attach-tag type-tag contents) (cons type-tag contents))


;using versions of type-tag and contents that allow untagged numbers to be seen as 'scheme-number
(define (type-tag datum)
  (cond
    ((number? datum) 'scheme-number)
    ((pair? datum) (car datum))
    (else (error "Bad tagged datum: TYPE-TAG" datum))
    )
  )
(define (contents datum)
  (cond
    ((number? datum) datum)
    ((pair? datum) (cdr datum))
    (else (error "Bad tagged datum: CONTENTS" datum))
    )
  )

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
            (let ((t1->t2 (get-coercion type1 type2))
                   (t2->t1 (get-coercion type2 type1)))
              (cond (t1->t2
                      (apply-generic op (t1->t2 a1) a2))
                (t2->t1
                  (apply-generic op a1 (t2->t1 a2)))
                (else (error "No method for these types"
                        (list op type-tags))))))
          (error "No method for these types"
            (list op type-tags))))))
  )

; personal implementation of get and put / get-coercion and put-coercion
(define op-table (list))
(define coercion-table (list))

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




(define (put-coercion op type proc)
  (set! coercion-table (cons (list op type proc) coercion-table)))

(define (get-coercion op type)

  (define (lookup op-list op type)
    (cond
      ((null? op-list) false)
      ((and (equal? op (caar op-list)) (equal? type (cadar op-list))) (caddar op-list))
      (else (lookup (cdr op-list) op type))
      )
    )
  (lookup coercion-table op type)
  )



