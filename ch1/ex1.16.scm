(define (square x) (* x x))


(define (even? n) (= (remainder n 2) 0))

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

; VERSION THAT PRODUCES AN ITERATIVE PROCESS
; It took me a few minutes to come up with this.
; The book says it's a good strategy to think in terms of 'invariants', a * (b ** n) being the invariant here.
; a couple remarks that maybe would have helped me: it's not something smart. 
; The goal is just to store the calculation in args.
; The algorithm is the same ! no need to look for something fancy.
(define (fast-expt-helper b n a)
  (cond ((= n 0) a)
        ((even? n) (fast-expt-helper (square b) (/ n 2) a))
        (else (fast-expt-helper b (- n 1) (* a b)))
  )
  )


(define (fast-expt-iter b n) (fast-expt-helper b n 1))

(fast-expt-iter 3 2)
(fast-expt-iter 2 5)
; expected: 32
