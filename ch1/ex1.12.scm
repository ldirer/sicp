
(define (pascal k n) 
  (cond ((= k 0) 1)
        ((= n 1) 1)
        ((= k n) 1)
        ((> k n) 0)
        (else (+ (pascal (- k 1) (- n 1)) (pascal k (- n 1))))
        ))

(pascal 1 4)
; 4
(pascal 2 4)
; 6
(pascal 2 5)
; 10
(pascal 3 5)
; 10
