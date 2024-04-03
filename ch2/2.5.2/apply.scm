(define (attach-tag type-tag contents) (cons type-tag contents))


; using versions of type-tag and contents that allow untagged numbers to be seen as 'scheme-number
; see ex2.78
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

            (if (equal? type1 type2)
              ; avoid coercion if arguments are the same type (ex2.81)
              (error "No method for " (list op type-tags))
              (let ((t1->t2 (get-coercion type1 type2))
                     (t2->t1 (get-coercion type2 type1)))
                (cond
                  (t1->t2 (apply-generic op (t1->t2 a1) a2))
                  (t2->t1 (apply-generic op a1 (t2->t1 a2)))
                  (else (error "No method for these types"
                          (list op type-tags))))))
            )
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



(define (put-coercion t1 t2 proc)
  (set! coercion-table (cons (list t1 t2 proc) coercion-table)))

(define (get-coercion t1 t2)
  (begin
    (display "\n")
    (display "get-coercion t1 t2")
      (display t1)
    (display " ")
    (display t2)
    (display "\n")
    )
  (define (lookup fn-list t1 t2)
    (cond
      ((null? fn-list) false)
      ((and (equal? t1 (caar fn-list)) (equal? t2 (cadar fn-list))) (caddar fn-list))
      (else (lookup (cdr fn-list) t1 t2))
      )
    )
  (begin (display "(lookup coercion-table t1 t2)")
    (display "\n")
           (display (lookup coercion-table t1 t2))
         (display "\n")
    )
  (lookup coercion-table t1 t2)
  )



