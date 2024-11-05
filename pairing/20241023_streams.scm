(load "pairing/20241009_streams.scm")


(define ones (cons-stream 1 ones))
;1 1 1...

(define (add-streams s1 s2) (stream-map + s1 s2))

;(define incrementing-stream (cons-stream 1 ones))
(define incrementing-stream (cons-stream 1 (add-streams incrementing-stream ones)))
(take incrementing-stream 10)

;(define ones-list (cons 1 ones-list))
;(define (f-rec n) (f-rec))
(define special-test (and false special-test))
;special-test
; expected: false

;(add-streams ones ones)



;Exercise 3.58: Give an interpretation of the stream com-
;puted by the following procedure:
;(define (expand num den radix)
;(cons-stream
;(quotient (* num radix) den)
;(expand (remainder (* num radix) den) den radix)))
;(quotient is a primitive that returns the integer quotient of
;two integers.) What are the successive elements produced
;by (expand 1 7 10)? What is produced by (expand 3 8
;10)?

(define (expand num den radix)
  (cons-stream
    (quotient (* num radix) den)
    (expand (remainder (* num radix) den) den radix))
  )
;quotient n p
;n = quotient * p + remainder
;modulo n p = remainder

;1 * 10 = 10
;10 = 7 * 1 + 3
; quotient: 1, remainder: 3
; expand 3 7 10
; 3*10 = 30
; 30 = 7 * 4 + 2
; quotient: 4, remainder: 2
(take (expand 1 7 10) 5)
;(quotient (* 1 10) 7)
; our guess: (1 4 2 8 5 7
;0.142857

(take (expand 3 8 10) 5)
; our guess: 0.3741
; Python's guess: 0.375
