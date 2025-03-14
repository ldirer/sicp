
(define (an-integer-starting-from low)
  (amb low (an-integer-starting-from (+ low 1)))
  )

; [low; high]
(define (an-integer-between low high)
  (require (<= low high))
  (amb low (an-integer-between (+ low 1) high))
  )

; Ben Bitdiddle proposes:
(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high))
         (hsq (* high high)))
    (let ((j (an-integer-between i high)))
      (let ((ksq (+ (* i i) (* j j))))
        (require (>= hsq ksq))
        (let ((k (sqrt ksq)))
          (require (integer? k))
          (list i j k)
          )
        )
      )
    )
  )

(a-pythagorean-triple-between 1 100)
try-again
try-again
try-again
try-again
try-again


; Ben is correct that this is more efficient.
; If N = high - low, the number of explored possibilities is N*(N+1)/2 (half square with diagonal).
; In the other procedure, we explore N**3 possibilities.