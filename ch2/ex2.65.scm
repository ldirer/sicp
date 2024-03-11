(load "ch2/ex2.63.scm")
(load "ch2/ex2.64.scm")

; we can combine the O(n) methods to convert trees to ordered lists and the O(n) procedures to interesect/union sets as ordered lists
; this gives us an overall O(n) implementation (though very likely not optimal).
(define (union-set-ordered-list set1 set2)
  (cond
    ((null? set1) set2)
    ((null? set2) set1)
    ((= (car set1) (car set2)) (cons (car set1) (union-set-ordered-list (cdr set1) (cdr set2))))
    ((< (car set1) (car set2)) (cons (car set1) (union-set-ordered-list (cdr set1) set2)))
    (else (cons (car set2) (union-set-ordered-list set1 (cdr set2))))
    )
  )
(define (intersection-set-ordered-list set1 set2)
  (if (or (null? set1) (null? set2))
    '()
    (let ((x1 (car set1)) (x2 (car set2)))
      (cond ((= x1 x2)
              (cons x1 (intersection-set-ordered-list (cdr set1)
                         (cdr set2))))
        ((< x1 x2)
          (intersection-set-ordered-list (cdr set1) set2))
        ((< x2 x1)
          (intersection-set-ordered-list set1 (cdr set2)))))))


(define (intersection-set set1 set2)
  (list->tree (intersection-set-ordered-list (tree->list-1 set1) (tree->list-1 set2)))
  )
(define (union-set set1 set2)
  (list->tree (union-set-ordered-list (tree->list-1 set1) (tree->list-1 set2)))
  )


(define set1 (list->tree '(1 3 4 5 7 9)))
(define set2 (list->tree '(3 4 6 9 11 12)))

(tree->list-1 (union-set set1 set2))
; expected: (1 3 4 5 6 7 9 11 12)
(tree->list-1 (intersection-set set1 set2))
; expected: (3 4 9)
