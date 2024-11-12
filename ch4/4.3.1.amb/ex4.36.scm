; assuming amb and require are available.

(define (an-integer-starting-from low)
  (amb low (an-integer-starting-from (+ low 1)))
  )

; [low; high]
(define (an-integer-between low high)
  (require (<= low high))
  (amb low (an-integer-between (+ low 1) high))
  )


(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
    (let ((j (an-integer-between i high)))
      (let ((k (an-integer-between j high)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))
    )
  )

; the book mentions this is not an adequate solution to generate all pythagorean triples:
(define (a-pythagorean-triple)
  (let ((i (an-integer-starting-from 1)))
    (let ((j (an-integer-starting-from i)))
      (let ((k (an-integer-starting-from j)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))
    )
  )

; Indeed the version above will never find a triple because it will explore the space of triples like such:
; (0, 0, 0), (0, 0, 1), (0, 0, 2), ...
; Basically it advances *only k*.
; Since there is no upper bound on how far we can advance k, it will never find a valid non-zero triple.
; Loops indefinitely, adding 'display' statements to the generator functions shows it is "k" the interpreter iterates on.
;(a-pythagorean-triple)


; We could write a-triple-of-naturals to produce triples in a relevant order, like in ex3.69.
; But I think this version does the trick:
; the key point is that we want all i, j, and k to make progress.
(define (a-pythagorean-triple)
  (let ((k (an-integer-starting-from 1)))
    (let ((j (an-integer-between 1 k)))
      (let ((i (an-integer-between 1 j)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))
    )
  )

(a-pythagorean-triple)
try-again
try-again
try-again


