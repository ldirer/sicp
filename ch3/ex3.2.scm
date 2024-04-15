(load "testing.scm")


(define (make-monitored f)

  (define counter 0)
  ; mf 'monitored f'
  (define (mf arg)
    (cond
      ((eq? arg 'reset-count) (set! counter 0))
      ((eq? arg 'how-many-calls?) counter)
      (else
              (set! counter (+ counter 1))
              (f arg)
        )
      )
    )
  mf
  )

(define s (make-monitored sqrt))


(s 100)
(s 144)

(check-equal "call count" (s 'how-many-calls?) 2)
(s 100)
(s 'reset-count)
(check-equal "call count was reset" (s 'how-many-calls?) 0)
