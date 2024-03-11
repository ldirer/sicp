(load "ch2/ex2.61.scm")

; sets as ordered lists
; O(n) (length set 1 + length set 2 iterations)
(define (union-set set1 set2)
  (cond
    ((null? set1) set2)
    ((null? set2) set1)
    ((= (car set1) (car set2)) (cons (car set1) (union-set (cdr set1) (cdr set2))))
    ((< (car set1) (car set2)) (cons (car set1) (union-set (cdr set1) set2)))
    (else (cons (car set2) (union-set set1 (cdr set2))))
    )
  )

(union-set '(1 2 5 7) '(1 3 4 5 6))
; expected: (1 2 3 4 5 6 7)
(union-set '(1 2) '())
; expected: (1 2)
