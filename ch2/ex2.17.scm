; last-pair seems to be a builtin
(define (last-pair-2 items) 
  (let ((tail (cdr items)))
    (if (null? tail)
      (car items)
      (last-pair-2 tail)
    )
  )
)


(last-pair-2 (list 23 72 149 34))
