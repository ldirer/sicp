(load "ch2/ex2.67.scm")
(load "ch2/ex2.68.scm")

; pairs of symbol, frequency
(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs))
  )


(define (successive-merge leaves)
  (cond
    ((null? (cdr leaves)) (car leaves))
    (else (successive-merge
            (adjoin-set
              (make-code-tree
                (car leaves)
                (cadr leaves)
                )
              (cddr leaves)
              )
            )
      )
    )
  )

; Tested this code with the next exercise.
