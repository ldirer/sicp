; use myamb

(ramb 1 2 3 4)
(ramb 1 2 3 4)
(ramb 1 2 3 4)

(define items (list 1 2 3 4))
(apply ramb items)


(apply + 1 2 (list 3 4))
; expected: 10


; trickier
(define items (list 'a 'b 'c))
(apply ramb items)
