(define (square x) (* x x))

(define (tree-map proc tree)
  (define (helper subtree)
    (if (not (pair? subtree))
      (proc subtree)
      (tree-map proc subtree)
      )
    )
  (map helper tree)
  )


(define (square-tree tree) (tree-map square tree))

(square-tree (list 1
                   (list 2 (list 3 4) 5)
                   (list 6 7)
               ))
; expected: (1 (4 (9 16) 25) (36 49))
