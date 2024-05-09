(load "ch3/ex3.61.scm")


; book version
(define (average a b)
  (/ (+ a b) 2)
  )

(define (make-call-counter)
  (define count 0)

  (define (set-count! v)
    (set! count v)
    )
  (define (register f)
    (define (wrapper . args)
      (set! count (+ count 1))
      (apply f args)
      )
    wrapper
    )


  (define (dispatch m)
    (cond
      ((eq? m 'count) count)
      ((eq? m 'set-count!) set-count!)
      ((eq? m 'register) register)
      )
    )

  dispatch
  )

(define counter (make-call-counter))

(define (sqrt-improve guess x)
  (average guess (/ x guess))
  )

(define sqrt-improve ((counter 'register) sqrt-improve))

(define (sqrt-stream x)

  (define guesses
    (cons-stream
      1.0
      (stream-map
        (lambda (guess) (sqrt-improve guess x))
        guesses
        )
      )
    )

  guesses
  )



;exercise version
(define (sqrt-stream-louis-reasoner x)
  (display "Louis louis")
  (display-line x)
  (cons-stream 1.0
    (stream-map
      (lambda (guess) (sqrt-improve guess x)) (sqrt-stream-louis-reasoner x)))
  )

;(display-stream (until (sqrt-stream 2) 10))


;> Alyssa P. Hacker replies that this version of the procedure is considerably less efficient
;> because it performs redundant computation.
;> Explain Alyssa's answer.
;> Would the two versions still differ in efficiency if our implementation of delay used
;> only (lambda () <exp>) without using the optimization provided by memo-proc ?


; It performs redundant computation because the function call is repeated.
; When making the recursive call, we create a new stream so we have to recompute the first and second term so we can get the third one.
; to get the fourth one we need to recompute the third term. That needs to recompute the first and second term.
; So to get the n-th term we need n computations.
; Not crystal-clear for me at the time of writing... Testing the code below.

(display-stream (until (sqrt-stream-louis-reasoner 2) 10))
(counter 'count)
;Value: 55 (= 10+9+8+7+..+1)

((counter 'set-count!) 0)
(display-stream (until (sqrt-stream 2) 10))
(counter 'count)
;Value: 10


; if we didn't have the memo-proc optimization, implementations would not differ in efficiency