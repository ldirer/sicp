
(define op-table (list))

(define (put op type proc)
  (set! op-table (cons (list op type proc) op-table)))

(define (get op type)

  (define (lookup op-list op type)
    (cond
      ; in my implementations of this in previous chapters I returned an error here (not standard but convenient to debug)
      ; here we cannot do this because the code relies on checking for the existence of keys
      ((null? op-list) false)
      ((and (equal? op (caar op-list)) (equal? type (cadar op-list))) (caddar op-list))
      (else (lookup (cdr op-list) op type))
      )
    )
  (lookup op-table op type)
  )
