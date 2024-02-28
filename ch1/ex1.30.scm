
; linear recursion
(define (sum term a next b) 
  (if (> a b) 
    0
    (+ (term a)
     (sum term (next a) next b)
    )))


; procedure generating an iterative process
(define (sum term a next b)
  (define (iter a result)
  (if (> a b) 
    result
    (iter (next a) (+ (term a) result)))
  )
  (iter a 0)
  )

(define (inc x) (+ x 1))

(sum cube 1 inc 10)
; 3025  ; \o/

