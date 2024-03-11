(load "ch2/ex2.67.scm")

(define (encode message tree)
  (if (null? message)
    '()
    (append (encode-symbol (car message) tree)
      (encode (cdr message) tree)))
  )

;using the basic version of element of set (assuming unordered list representation)
(define (element-of-set? x set)
  (cond ((null? set) false)
    ((equal? x (car set)) true)
    (else (element-of-set? x (cdr set)))))

(define (encode-symbol s tree)

  (define (encode-symbol-helper s tree)
    (if (leaf? tree)
      (list)
      (let (
             (left-symbols (symbols (left-branch tree)))
             (right-symbols (symbols (right-branch tree)))
             )
        (cond
          ((element-of-set? s left-symbols) (cons 0 (encode-symbol-helper s (left-branch tree))))
          ((element-of-set? s right-symbols) (cons 1 (encode-symbol-helper s (right-branch tree))))
          )
        )
      )
    )
  ; use the set of symbols stored on each node
  (if (not (element-of-set? s (symbols tree)))
    (error "bad symbol - not found in tree " s)
    (encode-symbol-helper s tree)
    )
  )

(encode-symbol 'a sample-tree)

(encode '(a d a b b c a) sample-tree)
; expected: (0 1 1 0 0 1 0 1 0 1 1 1 0)

(decode (encode '(a d a b b c a) sample-tree) sample-tree)
; expected: (a d a b b c a)
