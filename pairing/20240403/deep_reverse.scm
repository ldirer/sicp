;2.27
;
; Goal: make it produce an iterative process \o/... cliffhanger
(define (deep-reverse items)
  (define (deep-reverse-iter items result)
    (cond
      ((null? items) result)
      ((pair? (car items)) (deep-reverse-iter
                             (cdr items)
                             (cons (deep-reverse-iter (car items) (list)) result))
        )
      (else (deep-reverse-iter (cdr items) (cons (car items) result)))
      )
    )
  (deep-reverse-iter items (list))
  )

