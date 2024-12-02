; use myamb

; copied from ex4.35, replaced require with require-special
; verified the behavior is the same.

(define (an-integer-starting-from low)
  (amb low (an-integer-starting-from (+ low 1)))
  )

; [low; high]
(define (an-integer-between low high)
  (require-special (<= low high))
  (amb low (an-integer-between (+ low 1) high))
  )


(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
    (let ((j (an-integer-between i high)))
      (let ((k (an-integer-between j high)))
        (require-special (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))
    )
  )

(a-pythagorean-triple-between 1 10)

try-again
try-again
