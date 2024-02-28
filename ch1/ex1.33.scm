(define (filter-accumulate combiner null-value term a next b filter?) 
  (define (helper combiner term a next b filter? accumulator) 
    (cond ((> a b) accumulator)
           ((filter? a) (helper combiner term (next a) next b filter? (combiner accumulator (term a))))
           (else (helper combiner term (next a) next b filter? accumulator))
    ))
  (helper combiner term a next b filter? null-value)
  )
)

(define (square x) (* x x))
(define (inc x) (+ x 1))
(define (id x) x)
(define (sum-squared-primes a b) (filter-accumulate + 0 square a inc b prime?))

(define (relative-prime? p n) (= (gcd p n) 1))
(define (product-relative-primes n) (filter-accumulate * 1 id 1 inc n (lambda (p) (relative-prime? p n))))


(define (prime? n) 
  (define (helper i n) 
    (cond ((= i n) true)
           (else (and (relative-prime? i n) (helper (+ i 1) n)))
    ))
  (helper 2 n)
  )



(product-relative-primes 100) 
(sum-squared-primes 1 100)
