(load "ch3/ex3.70.scm")

(define (stream-cadr s)
  (stream-car (stream-cdr s))
  )

(define (stream-cddr s)
  (stream-cdr (stream-cdr s))
  )

(define (cube x) (* x x x))

(define (weight-rama pair)
  (+ (cube (car pair)) (cube (cadr pair)))
  )

(define searchable-stream (weighted-pairs integers integers weight-rama))
;(display-stream (until (stream-map weight-rama searchable-stream) 70))


(define (consecutive-stream s weight)
  (define (iter prev s weight)
;    (display-line prev)
;    (display (weight prev))
;    (display " vs ")
;    (display (weight (stream-car s)))
;    (newline)

    (if (= (weight (stream-car s)) (weight prev))
      (cons-stream (list prev (stream-car s) (weight prev)) (iter (stream-cadr s) (stream-cddr s) weight))
      (iter (stream-car s) (stream-cdr s) weight)
      )
    )

  (iter (stream-car s) (stream-cdr s) weight)
  )

(define rama-numbers (consecutive-stream searchable-stream weight-rama))
(display-stream (until rama-numbers 6))
;((9 10) (1 12) 1729)
;((9 15) (2 16) 4104)
;((18 20) (2 24) 13832)
;((19 24) (10 27) 20683)
;((18 30) (4 32) 32832)
;((15 33) (2 34) 39312)

