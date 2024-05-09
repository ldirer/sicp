(load "ch3/ex3.63.scm")
(define (stream-limit s tolerance)
  (define (iter s previous)
    (if (and (not (equal? previous 'init)) (< (abs (- (stream-car s) previous)) tolerance))
      (stream-car s)
      (iter (stream-cdr s) (stream-car s))
      )
    )

  ; better version just calls iter on (stream-cdr s) (stream-car s) (https://mk12.github.io/sicp/exercise/3/5.html#ex3.64)
  ; removes the need for sentinel value
  (iter s 'init)
  )


(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance)
  )

(sqrt 2 0.01)


