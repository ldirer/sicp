(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op
      (car sequence)
      (accumulate op initial (cdr sequence))
      )
    )
  )

; t: tree as a list (children)
; if children has lists as items then they are trees, if they aren't lists they're values.
(define (count-leaves t)
  (accumulate FILL1 FILL2 (map FILL3 FILL4))
  )


(define a (list 1
                (list 2 (list 3 4) 5)
                (list 6 7)
            ))

(count-leaves a)
; expected: 7
