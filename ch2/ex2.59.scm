; from book
(define (element-of-set? x set)
  (cond ((null? set) false)
    ((equal? x (car set)) true)
    (else (element-of-set? x (cdr set)))))


(define (adjoin-set x set)
  (if (element-of-set? x set)
    set
    (cons x set)))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
    ((element-of-set? (car set1) set2)
      (cons (car set1) (intersection-set (cdr set1) set2)))
    (else (intersection-set (cdr set1) set2))))

; /from book

(define (union-set set1 set2)
  (cond
    ((null? set1) set2)
    ((element-of-set? (car set1) set2) (union-set (cdr set1) set2))
    (else (cons (car set1) (union-set (cdr set1) set2)))
    )
  )



(union-set '(1 2 3) '(2 3 4))
; expected: (1 2 3 4)
(union-set '(1 2) '())
; expected (1 2)
(union-set '(1 2) '(12))
; expected (1 2 12)

