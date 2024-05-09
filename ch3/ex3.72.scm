(load "ch3/ex3.70.scm")

(define (stream-cadr s)
  (stream-car (stream-cdr s))
  )

(define (stream-cddr s)
  (stream-cdr (stream-cdr s))
  )

(define (square x) (* x x))

(define (weight-squares pair)
  (+ (square (car pair)) (square (cadr pair)))
  )

(define searchable-stream (weighted-pairs integers integers weight-squares))
;(display-stream (until (stream-map weight-rama searchable-stream) 70))


(define (consecutive-stream s weight)
  (define (iter prev-identicals prev s weight)
    ;    (display-line prev)
    ;    (display (weight prev))
    ;    (display " vs ")
    ;    (display (weight (stream-car s)))
    ;    (newline)

    (cond
      ((= (weight (stream-car s)) (weight prev))
        (iter (cons (stream-car s) prev-identicals) (stream-car s) (stream-cdr s) weight))
      ((< (length prev-identicals) 3)
        ; can't mutualize this value because it would be evaluated straight away and we need the delay from
        ; stream-cons to make it not loop indefinitely
        (iter (list (stream-car s)) (stream-car s) (stream-cdr s) weight)
        )
      (else (cons-stream (cons prev-identicals (weight prev)) (iter (list (stream-car s)) (stream-car s) (stream-cdr s) weight))
        )
      )
    )
  (iter (list (stream-car s)) (stream-car s) (stream-cdr s) weight)
  )

(define sum-of-two-squares-numbers (consecutive-stream searchable-stream weight-squares))
(display-stream (until sum-of-two-squares-numbers 6))
;(((1 18) (6 17) (10 15)) . 325)
;(((5 20) (8 19) (13 16)) . 425)
;(((5 25) (11 23) (17 19)) . 650)
;(((7 26) (10 25) (14 23)) . 725)
;(((2 29) (13 26) (19 22)) . 845)
;(((3 29) (11 27) (15 25)) . 850)