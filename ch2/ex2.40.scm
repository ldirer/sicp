

; copied from the book
(define (smallest-divisor n) (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
    ((divides? test-divisor n) test-divisor)
    (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b) (= (remainder b a) 0))
(define (prime? n)
  (= n (smallest-divisor n)))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair)))
  )

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))


(define accumulate fold-right)

(define (flatmap proc seq) (
                             accumulate append (list) (map proc seq)
                             ))

; returned values include both a and b ([a; b])
(define (enumerate-interval a b)
  (define (enumerate-interval-iter a b current)
    (if (> a b)
      current
      (enumerate-interval-iter a (- b 1) (cons b current))
      )
    )

  (enumerate-interval-iter a b (list))
  )

(enumerate-interval 1 10)

; sequence of pairs (i, j) with 1 ≤ j < i ≤ n.
(define (unique-pairs n)
  (flatmap (lambda (i) (map (lambda (j) (list i j)) (enumerate-interval 1 (- i 1)))) (enumerate-interval 1 n)
    )
  )

(unique-pairs 5)

(define (prime-sum-pairs n)
  (map make-pair-sum
    (filter prime-sum? (unique-pairs n))
    )
  )

(prime-sum-pairs 10)