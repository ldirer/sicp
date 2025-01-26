; use eceval-normal
; from exercise 4.27.
(define count 0)
(define (id x)
  (set! count (+ count 1))
  x
  )

(define w (id (id 10)))

;;; L-eval input
count
; expecting: 1

;;; L-eval input
w
; expecting: 10

;;; L-eval input
count
; expecting 2

