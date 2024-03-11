(load "ch2/ex2.47.scm")

(define (make-segment start end)
  (list start end)
  )

(define (start-segment segment)
  (car segment)
  )
(define (end-segment segment)
  (cadr segment)
  )
