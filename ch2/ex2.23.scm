(define (for-each-wrong-order proc items)
  (define (do-first-return-second first second)
    second
    )
  (if (null? items) true
    (do-first-return-second (proc (car items)) (for-each proc (cdr items)))
  )
  )


(for-each-wrong-order (lambda (x) (newline) (display x))
          (list 57 321 88)
          )


(define (for-each-2 proc items)
  (cond ((null? items) true)
    (else (proc (car items))
      (for-each proc (cdr items)))
    )
  )


(for-each-2 (lambda (x) (newline) (display x))
  (list 57 321 88)
)

; this seems to show arguments are evaluated 'last argument first'.
(define (for-each-correct-order proc items)
  (define (do-first-return-second second first)
    second
    )
  (if (null? items) true
                    (do-first-return-second (for-each proc (cdr items)) (proc (car items)) )
    )
  )

(for-each-correct-order (lambda (x) (newline) (display x))
  (list 57 321 88)
  )
