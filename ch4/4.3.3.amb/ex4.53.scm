; use myamb

;copying a bunchastuff
(define (square x) (* x x))
(define (smallest-divisor n) (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
    ((divides? test-divisor n) test-divisor)
    (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b) (= (remainder b a) 0))
(define (prime? n)
  (= n (smallest-divisor n)))

(define (prime-sum-pair list1 list2)
  (let ((a (an-element-of list1))
         (b (an-element-of list2)))
    (require (prime? (+ a b)))
    (list a b))
  )

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items)))
  )


; The code for the exercise
; > What will be the result of evaluating:
(let ((pairs '()))
  (if-fail (let ((p (prime-sum-pair '(1 3 5 8) '(20 35 110))))
             (permanent-set! pairs (cons p pairs))
             (amb))
    pairs))

; I think we'll see the list of pairs from the cartesian product of the two lists whose sum is prime.
; I'm also not sure I really see the point of this exercise!
; I guess it's about whether the fail in (amb) triggers an 'exit' from the if-fail first expression.
; Hmm... I think it does not exit until we exhausted all prime-sum-pair options.

; Running it:
;;;; Amb-Eval value
;((8 35) (3 110) (3 20))

;; Just to be sure these were *all* the prime pairs I confirmed we run out of options with:
;(prime-sum-pair '(1 3 5 8) '(20 35 110))
;try-again
;try-again
;try-again
