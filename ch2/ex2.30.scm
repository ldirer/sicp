(define (square x) (* x x))

(define (square-tree tree)
  (cond ((null? tree) (list))
    ((not (pair? tree)) (square tree))
    (else (cons
            (square-tree (car tree))
            (square-tree (cdr tree))
            )
      )
    )
  )



(square-tree (list 1
                   (list 2 (list 3 4) 5)
                   (list 6 7)
               ))
; expected: (1 (4 (9 16) 25) (36 49))



; VERSION USING MAP AND RECURSION
(define (square-tree tree)
  (define (helper subtree)
    (cond
      ((not (pair? subtree)) (square subtree))
      (else (square-tree subtree))
    )
    )
  (map helper tree)
  )



(square-tree (list 1
                   (list 2 (list 3 4) 5)
                   (list 6 7)
               ))
; expected: (1 (4 (9 16) 25) (36 49))
