(define (subsets s)
  (if (null? s)
    (list (list))
    (let ((rest (subsets (cdr s))))
      ; all subsets = subsets without the first element | subsets with the first element
      (append rest (map (lambda (set) (cons (car s) set)) rest))
      )
    )
  )

(subsets (list 1 2 3))
; expected (order not relevant): (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))
