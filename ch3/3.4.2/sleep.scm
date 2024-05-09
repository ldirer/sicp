; couldn't find this anywhere (I looked!) so I defined it
(define (sleep seconds)
  (define start (runtime))
  (define (iter)
    (if (< (- (runtime) start) seconds) (iter))
    )
  (iter)
  )

