(define (unique-query exps) (car exps))


(define (is-singleton? stream)
  (if (null? stream) #f (null? (stream-cdr stream)))
  )


; this receives something like ((job ?x ..))
(define (uniquely-asserted exps frame-stream)
  (stream-flatmap
    (lambda (frame)
      (define result-stream (qeval (unique-query exps) (singleton-stream frame)))
      (if (is-singleton? result-stream)
        result-stream
        the-empty-stream
        )
      )
    frame-stream
    )
  )
