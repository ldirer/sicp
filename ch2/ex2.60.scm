; with sets represented as lists that might have duplicates

; same as the 'list without duplicate' version
(define (element-of-set? x set)
  (cond ((null? set) false)
    ((equal? x (car set)) true)
    (else (element-of-set? x (cdr set)))))


; just add a possible duplicate
(define (adjoin-set x set) (cons x set))

; same as the 'list without duplicate' version
(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
    ((element-of-set? (car set1) set2)
      (cons (car set1) (intersection-set (cdr set1) set2)))
    (else (intersection-set (cdr set1) set2))))

; /from book

(define (union-set set1 set2) (append set1 set2))

(union-set '(1 2 3) '(2 3 4))
; expected: (1 2 3 2 3 4)
(union-set '(1 2) '())
; expected (1 2)
(union-set '(1 2) '(12))
; expected (1 2 12)


; element-of-set? and intersection will be slower since the sets will typically be larger.
; adjoin-set and union-set are much faster (O(1) for adjoin and O(n) for union).
; The representation with duplicates could be useful if we want to add elements fast and don't
; mind 'reading' (with 'element-of-set?') a little slower.
; I'd say it is especially a good choice if we know duplicates are unlikely. We won't pay a
; large penalty on intersection and element-of-set, and adding elements will be much faster.

