(define (subsets s)
  (if (null? s)
    (list (list))
    (let ((rest (subsets (cdr s))))
      (append rest
        (map (lambda (sub-subset) (cons (car s) sub-subset)) rest)))
    )
  )

(map square '(1 2 3))
;Value: (1 4 9)

(subsets (list 1 2 3))
; expected: (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))

; already computed: (subsets (2 3))
; (subsets (1 2 3))

; already computed: rest = (subsets (2 3))
; rest = () (2) (3) (2 3)
; (car s) = 1


;2.27
;
; Iterative \o/
(define (deep-reverse items)
  (define (deep-reverse-iter items result)
    (cond
      ((null? items) result)
      ((pair? (car items)) (deep-reverse-iter
                             (cdr items)
                             (deep-reverse-iter (car items) result))
        ))
      )
  (deep-reverse-iter items (list))
  )

(pair? (car (list 1)))
;expected: false

(define x (list (list 1 2) (list 3 4)))
;((1 2) (3 4))

(reverse x)
; expected: ((3 4) (1 2))
(deep-reverse x)
; expected: ((4 3) (2 1))