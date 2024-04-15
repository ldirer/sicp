(load "testing.scm")


(define (make-accumulator value)
  (define operation +)

  (lambda (item)
    (begin
      (set! value (operation value item))
      value
      )
    )
  )
(define A (make-accumulator 5))

(check-equal "stateful test one" (A 10) 15)
(check-equal "stateful test two" (A 10) 25)
