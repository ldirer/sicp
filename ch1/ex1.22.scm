; from the book
(define (smallest-divisor n) (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n) (= n (smallest-divisor n)))



(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime))
  )


(define (start-prime-test n start-time)
  (if (prime? n)
    (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))


; I feel like we have to specify a range end, the procedure we're supposed to use doesn't report a result.
; so we can't know when we found a prime or not.
(define (search-for-primes-helper range-start range-end whatever-needs-to-be-executed) 
   (cond ((> range-start range-end) 0)
         ((divides? 2 range-start) (search-for-primes-helper (+ range-start 1) range-end 0))
         (else (search-for-primes-helper (+ range-start 2) range-end (timed-prime-test range-start))
  )
         )
   )


(define (search-for-primes start end) (search-for-primes-helper start end 0))


; examples from the book run too fast on my machine, reported time is always 0
(search-for-primes 1000 1200)
(search-for-primes 10000 10200)
(search-for-primes 100000 100200)
(search-for-primes 1000000 1000200)


; sample timings :
(search-for-primes 1e10 (+ 1e10 200))
; .05999999999999994
; .07000000000000006
(search-for-primes 1e11 (+ 1e11 200))
; .19999999999999973
; .20999999999999996
(search-for-primes 1e12 (+ 1e12 200))
;.6499999999999999
;.6299999999999999

;In [2]: math.sqrt(10)
;Out[2]: 3.1622776601683795

; since the complexity is O(sqrt(n)), we expect 10*n to take about sqrt(10) times the time taken for n.
; Looks consistent with the timings.


