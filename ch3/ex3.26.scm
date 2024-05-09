(load "testing.scm")

; overall this is a bit wonky.
; the core datastructure isn't mutated.
; but that could be considered an implementation detail.

; copied from chapter 2 exercises, with modifications made to adjoin-set
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
    ((= (key (entry set)) (key x)) (newline) (display "SAME KEY") (newline) (make-tree x (left-branch set) (right-branch set)))
    ((< (key (entry set)) (key x)) (make-tree (entry set) (left-branch set) (adjoin-set x (right-branch set))))
    (else (make-tree (entry set) (adjoin-set x (left-branch set)) (right-branch set)))
    )
  )



; assuming a binary tree representation for sets
(define (lookup given-key set-of-records)
  (cond
    ((null? set-of-records) false)
    ((= (key (entry set-of-records)) given-key) (entry set-of-records))
    ((< (key (entry set-of-records)) given-key) (lookup given-key (right-branch set-of-records)))
    (else (lookup given-key (left-branch set-of-records)))
    )
  )




; say records store their key as first item in a pair
(define (make-record key data) (cons key data))
(define (key record) (car record))
(define (data record) (cdr record))

;/end copying stuff from chapter 2 (ex 2.63 -> 2.66)




; in ex2.66 we implemented a binary tree where nodes where holding the (key, value) information.
; I feel like this is going to be the exact same result ?
; Maybe with a different that we have an extra node at the top (table header)

(define (make-table)

  (define tree '())

  (define (lookup-proc key)
    (let ((lookup-record (lookup key tree)))
      (if lookup-record
        (data lookup-record)
        false
        )
      )
    )

  (define (insert-proc! key value)
    (if (null? tree)
      (set! tree (make-tree (make-record key value) '() '()))
      (set! tree (adjoin-set (make-record key value) tree))
      )
    )

  (define (dispatch action)
    (cond
      ((equal? action 'lookup-proc) lookup-proc)
      ((equal? action 'insert-proc!) insert-proc!)
      )
    )

  dispatch
  )


;(define operation-table (make-table))
;(define get (operation-table 'lookup-proc))
;(define put (operation-table 'insert-proc!))
;

(define my-t (make-table))
(define get (my-t 'lookup-proc))
(define put (my-t 'insert-proc!))


(define test-tree (make-tree (cons 5 55) '() '()))
(adjoin-set (make-record 6 66) test-tree)
(adjoin-set (make-record 3 33) test-tree)
(adjoin-set (make-record 9 99) test-tree)

test-tree

(put 5 55)
(get 5)
(put 6 66)
(put 3 33)
(put 9 99)
(put 1 11)
(put 2 22)

(get 9)
; expected: 99
