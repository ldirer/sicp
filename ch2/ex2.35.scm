(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op
      (car sequence)
      (accumulate op initial (cdr sequence))
      )
    )
  )

; this does not match the template given in the book.
; in that template there's only a call to `accumulate`.
(define (count-leaves tree)
  (if (not (pair? tree))
    1
    (accumulate +
      0
      (map count-leaves tree)
      )
    )
  )


(define a (list 1
                (list 2 (list 3 4) 5)
                (list 6 7)
            ))

(count-leaves a)
; expected: 7




;version respecting the book's template.
(define (count-leaves tree)
  (accumulate +
    0
    (map (lambda (t)
           (if (not (pair? t))
             1
             (count-leaves t)
             ))
      tree)
    )
  )


(define a (list 1
                (list 2 (list 3 4) 5)
                (list 6 7)
            ))
(count-leaves a)
; expected: 7
