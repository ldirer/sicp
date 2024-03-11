(load "ch2/ex2.40.scm")
;summing to s, all elements <= n
(define (find-triplets n s)


  (define (sum-matches triplet)
    (= (fold-right + 0 triplet) s)
    )

  (filter sum-matches (unique-triplets n))

  )

; distinct, positive triplets (<= n)
; this was a pain to write. Might be easier to write something *more* general.
(define (unique-triplets n)
  (flatmap
    (lambda (i) (flatmap
                  (lambda (j)
                    (map
                      (lambda (k) (list i j k))
                      (enumerate-interval 1 (- j 1))
                      )
                    )
                  (enumerate-interval 1 (- i 1))
                  ))
    (enumerate-interval 1 n)
    )
  )

(unique-triplets 5)
(find-triplets 10 20)