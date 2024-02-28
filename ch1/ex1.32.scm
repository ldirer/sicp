; recursive process 
(define (accumulate combiner null-value term a next b)
  (cond ((> a b) null-value)
        (else (combiner (term a) (accumulate combiner null-value term (next a) next b)))
  )
)

; iterative process
(define (accumulatei combiner null-value term a next b)
   (define (accumulate-helper combiner term a next b accumulator)
  (cond ((> a b) accumulator)
        (else (accumulate-helper combiner term (next a) next b (combiner (term a) accumulator)))
  ))
  (accumulate-helper combiner term a next b null-value)
)


(define (inc x) (+ x 1))
(define (id x) x)

(define (sum term a next b) (accumulate + 0 term a next b))
(define (sumi term a next b) (accumulatei + 0 term a next b))
(define (product term a next b) (accumulate * 1 term a next b))
(define (producti term a next b) (accumulatei * 1 term a next b))


(sumi id 1 inc 10)
; 55
(sum id 1 inc 10)
; 55
(producti id 1 inc 10)
; 3628800
(product id 1 inc 10)
; 3628800

