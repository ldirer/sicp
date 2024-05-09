(load "ch3/3.5/streams.scm")
(define sum 0)
(define (accum x) (set! sum (+ x sum)) sum)
(define seq
  (stream-map accum
    (stream-enumerate-interval 1 20)))
sum
;Value: 1
(define y (stream-filter even? seq))
sum
;Value: 6
(define z
  (stream-filter (lambda (x) (= (remainder x 5) 0))
    seq))
sum
; 1+2+3+4
;Value: 10

(stream-ref y 7)
;Value: 136
; seq: 1 3 6 10 15 21 28 36 45 55 66 78 91 105 120 136
; y: 6 10 28 36 66 78 120 136
;sum: 136
(display-stream z)
;prints 10 15 45 55 105 120 190 210
;sum: 210

;What is the value of sum after each of the above expressions
;is evaluated? What is the printed response to evaluating
;the stream-ref and display-stream expressions? Would
;these responses differ if we had implemented (delay ⟨exp⟩)
;simply as (lambda () ⟨exp⟩) without using the optimiza-
;tion provided by memo-proc? Explain.

;If we did not have memo-proc, the 'map' function would be run multiple times for the same item.
;The responses would be very different, because accessing a member of the stream already seen would run accum again, changing sum.
;One consequence is that repeatedly reading the first element of the stream would give a different result each time.