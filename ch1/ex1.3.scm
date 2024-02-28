(define (sum_square a b) (+ (* a a) (* b b)))

(define (sum_square_two_larger a b c) 
  (cond ((and (<= a b) (<= a c)) (sum_square b c))
        ((and (<= b a) (<= b c)) (sum_square a c))
        (else (sum_square a b))
                                       ))


; (sum_square_two_larger 2 3 4)
; ;Value: 25
; (sum_square_two_larger 3 2 4)
; ;Value: 25
; (sum_square_two_larger 4 2 3)
; ;Value: 25
