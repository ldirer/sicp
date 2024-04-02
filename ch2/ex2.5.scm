
; 2 and 3 are prime which guarantees that no two pairs can have the same result.

; we can also show this directly
; 2^a * 3^b = 2^c * 3^d
; 2^(a-c) * 3^(b-d) = 1
; => a = c and b = d



(define (prime-factor n p)
  (define (iter n power)
    (if (= (remainder n p) 0)
      (iter (/ n p) (+ power 1))
      power
      )
    )
  (iter n 0)
  )

(prime-factor 18 2)
; 1

(prime-factor 18 3)
; 2

(define car)

