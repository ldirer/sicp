; sets as binary trees

(define (make-tree entry left right) (list entry left right))

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))


(define (element-of-set? x set)
  (cond
    ((null? set) false)
    ((= (entry set) x) true)
    ((< (entry set) x) (element-of-set? x (right-branch set)))
    (else (element-of-set? x (left-branch set)))
    )
  )
(define (adjoin-set x set)
  (cond
    ((null? set) (make-tree x '() '()))
    ((= (entry set) x) set)
    ((< (entry set) x) (make-tree (entry set) (left-branch set) (adjoin-set x (right-branch set))))
    (else (make-tree (entry set) (adjoin-set x (left-branch set)) (right-branch set)))
    )
  )

; wrote that as an exercise - the book turned out to go a different direction
(define (intersection-set set1 set2)
  (cond
    ((or (null? set1) (null? set2)) '())
    ((= (entry set1) (entry set2)) (make-tree
                                     (entry set1)
                                     (intersection-set (left-branch set1) (left-branch set2))
                                     (intersection-set (right-branch set1) (right-branch set2))
                                     )
      )
    ((< (entry set1) (entry set2)) ((make-tree
                                      ; we could build a tree with `(entry set1)` here too (adjusting branches)
                                      (entry set2)
                                      (intersection-set (left-branch set2) set1)
                                      (intersection-set (right-branch set1) (right-branch set2))
                                      )))
    (else ((make-tree
             (entry set1)
             (intersection-set (left-branch set1) set2)
             (intersection-set (right-branch set1) (right-branch set2))
             )))
    )
  )


(define balanced
  (make-tree
    10
    (make-tree 5 (make-tree 3 '() '()) (make-tree 7 '() '()))
    (make-tree 15 (make-tree 12 '() '()) (make-tree 20 '() '()))
    )
  )

(adjoin-set 9 balanced)
(adjoin-set 9 balanced)


(define (tree->list-1 tree)
  (if (null? tree)
    '()
    (append (tree->list-1 (left-branch tree))
      (cons (entry tree)
        (tree->list-1
          (right-branch tree)))))
  )

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
      result-list
      (copy-to-list (left-branch tree)
        (cons (entry tree)
          (copy-to-list
            (right-branch tree)
            result-list))))
    )
  (copy-to-list tree '())
  )


; reproducing trees from figure 2.16 (p211).
;{1, 3, 5, 7, 9, 11}
(define v1
  (make-tree
    7
    (make-tree 3
      (make-tree 1 '() '())
      (make-tree 5 '() '())
      )
    (make-tree 9
      '()
      (make-tree 11 '() '())
      )
    )
  )


(define v2
  (make-tree
    3
    (make-tree 1 '() '())
    (make-tree 7
      (make-tree 5 '() '())
      (make-tree 9
        '()
        (make-tree 11 '() '())
        )
      )
    )
  )

(define v3
  (make-tree
    5
    (make-tree 3
      (make-tree 1 '() '())
      '()
      )
    (make-tree 9
      (make-tree 7 '() '())
      (make-tree 11 '() '())
      )
    )
  )


; tree->list-1 prints a list of entries... left branch entry right branch
; entries in order basically.
(tree->list-1 v1)
(tree->list-1 v2)
(tree->list-1 v3)
; all 3 return (1 3 5 7 9 11)

; tree->list-2 does the same thing.
(tree->list-2 v1)
(tree->list-2 v2)
(tree->list-2 v3)


; both procedures are O(n) in number of steps.