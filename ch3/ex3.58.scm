;Give an interpretation of the stream computed by the following procedure:
(define (expand num den radix)
  (cons-stream
    (quotient (* num radix) den)
    (expand (remainder (* num radix) den) den radix))
  )

;(quotient is a primitive that returns the integer quotient of
;two integers.) What are the successive elements produced
;by (expand 1 7 10)? What is produced by (expand 3 8
;10)?

;(expand 1 7 10)
; expected:
; car = 10 // 7 = 1
; cdr = (expand 3 7 10)
; then... 30=4*7 + 2
; 20=2*7+6
; 60=8*7+4
; 40=5*7+5
; 50=7*7+1
; 10=1*7+3
; stream:
; 1 4 2 8 5 7 1 4 2 8 5 7 1 4...
; it's a division algorithm with infinite precision, in the base given by radix.

;(expand 3 8 10)
; 30=3*8+6
; 60=7*8+4
; 40=5*8+0
; expected stream: 3 7 5 0 0 0 0 0 ..

