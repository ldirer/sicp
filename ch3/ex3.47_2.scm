; b. implement semaphore using atomic test-and-set! operations.
(load "ch3/ex3.47_1.scm")
(load "ch3/3.4.2/serializer.scm")


(define (make-semaphore-2 n)
  (define count 0)
  (define cell (list false))

  (define (acquire)
    (if (test-and-set! cell)
      (cond
        ((< count n)
          (set! count (+ count 1))
          (clear! cell)
          )
        (else
          (clear! cell)
          (acquire))
        )
      (acquire)  ; retry
      )
    )

  (define (release)
    (if (test-and-set! cell)
      (begin
        (set! count (- count 1))
        ((clear! cell))
        )
      (release)  ; retry
      )
    )

  (define (the-semaphore action)
    (cond
      ((eq? action 'acquire) (acquire))
      ((eq? action 'release) (release))
      )
    )

  the-semaphore
  )
