(define x (list (list 1 2) (list 3 4)))

; return a list of leaves, in 'left to right' order.
; probably a better implementation below, here it feels like we're hardcoding an iteration of recursion when unpacking the tree.
(define (fringe tree)
  (if (null? tree)
    (list)
    (let ((left (car tree))
           (right (cdr tree)))
      (if (pair? left)
        (append (fringe left) (fringe right))
        (append (list left) (fringe right))
        )
      )
    )
  )

(fringe x)
; expected: (1 2 3 4)

(fringe (list x x))
; expected: (1 2 3 4 1 2 3 4)

(define (fringe2 node)
  (cond ((null? node) (list))
    ; leaf node
    ((not (pair? node)) (list node))
    (else (append
            (fringe2 (car node))
            (fringe2 (cdr node))))
    )
  )
(fringe2 x)
; expected: (1 2 3 4)

(fringe2 (list x x))
; expected: (1 2 3 4 1 2 3 4)
