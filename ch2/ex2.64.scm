(load "ch2/ex2.63.scm")
; from book
(define (list->tree elements)
  (car (partial-tree elements (length elements)))
  )

; elts is a sorted list
(define (partial-tree elts n)
  (if (= n 0)
    (cons '() elts)
    (let ((left-size (quotient (- n 1) 2)))
      (let (
             (left-result (partial-tree elts left-size))
             )
        (let (
               (left-tree (car left-result))
               (non-left-elts (cdr left-result))
               (right-size (- n (+ left-size 1)))
               )
          (let (
                 (this-entry (car non-left-elts))
                 (right-result
                   (partial-tree
                     (cdr non-left-elts)
                     right-size))
                 )
            (let (
                   (right-tree (car right-result))
                   (remaining-elts (cdr right-result))
                   )
              (cons (make-tree this-entry
                      left-tree
                      right-tree)
                remaining-elts))))))
    )
  )
; /from book


; a. partial-tree takes a sorted list. Takes n elements, splits them in two.
; since the list is sorted we'll want all items in the first part in the left tree.
; the rest in the right tree (minus the entry).
; then it's about making the relevant recursive calls.
; the fact that the procedure takes 'n' as parameter and returns unused elements
; makes it convenient to call recursively on the smaller cases.

(list->tree '(1 3 5 7 9 11))
; expected (confirmed):
;     5
;    / \
;   3   9
;  /   / \
; 1   7  11


; b. Order of growth to convert a list of n elements ?
; O(n) because each step reduces the problem to two subproblems of size (n - 1) / 2 each.