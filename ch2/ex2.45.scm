(define (split split1 split2)
  (define (split_ painter n)
    (if (= n 0)
      painter
      (let ((smaller (split_ painter (- n 1))))
        (split1 painter (split2 smaller smaller))
        )
      )
    )
  split_
  )