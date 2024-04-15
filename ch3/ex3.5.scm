(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range)))
  )


(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond
      ((= trials-remaining 0) (/ trials-passed trials))
      ((experiment) (iter (- trials-remaining 1) (+ trials-passed 1)))
      (else (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))



; P: predicate
(define (estimate-integral P x1 x2 y1 y2 n-trials)

  (define (experiment)
    (P (random-in-range x1 x2) (random-in-range y1 y2))
    )

  ; return value is the proportion of the area of the rectangle
  (* (monte-carlo n-trials experiment) (* (- x2 x1) (- y2 y1)))
  )

(define (P-in-unit-disk x y)
  (<= (+ (square x) (square y)) 1)
  )


(define (estimate-pi n-trials)
  ; NEED TO USE NON-INTEGERS. There's `exact->inexact` that we could use maybe to make this less of a footgun.
  (estimate-integral P-in-unit-disk -2. 2. -2. 2. n-trials)
  )

;(random-in-range -1. 1.)
(estimate-pi 100000)
