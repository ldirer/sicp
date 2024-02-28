
(define (f g)
  (g 2))

(f (lambda (z) (* z (+ z 1))))
; 6

(f f)
; prediction: this will end up with '2 cannot be evaluated' or something.
; actual:
; The object 2 is not applicable.


