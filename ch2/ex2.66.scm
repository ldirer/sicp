(load "ch2/ex2.63.scm")
(load "ch2/ex2.64.scm")


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


(define records1
    (make-tree
      (make-record 5 "five")
      (make-tree (make-record 3 "three")
        (make-tree (make-record 1 "one") '() '())
        '()
        )
      (make-tree (make-record 9 "nine")
        (make-tree (make-record 7 "seven") '() '())
        (make-tree (make-record 11 "eleven") '() '())
        )
      )
  )


(lookup 7 records1)
;Value: (7 . "seven")