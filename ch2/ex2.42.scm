(load "ch2/ex2.41.scm")


(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
      (list empty-board)
      (filter
        (lambda (positions) (safe? k positions))
        (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position
                     new-row k rest-of-queens))
              (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))


; a solution can be represented as a list of integers.
; 1st element in the list is the position of the queen in the first column, etc.
; -> that would work but... not sure. Might be more convenient to store a list of pairs with the column index directly
; in the pair.
(define empty-board (list))

(define (make-board-position row-idx col-idx) (list row-idx col-idx))

(define (get-row position) (car position))
(define (get-col position) (cadr position))

(define (adjoin-position row-idx k rest-of-queens)
  (cons (make-board-position row-idx k) rest-of-queens)
  )


(define (conflict-pos? position row-k col-k)
  (let ((row (get-row position))
         (col (get-col position)))
    (or (= row row-k)
      ; diagonal
      (= (abs (- col-k col)) (abs (- row-k row)))
      )
    )
  )

(define (safe? k positions)
  (if (null? positions)
    true
    ; a bit lame to use `car` here ? Assumes positions are ordered with the k-th position first...
    (let (
           ; can't reuse `pos-k` in another variable definition inside the same `let`
           ;(pos-k (car positions))
           (other-positions (cdr positions))
           (row-k (get-row (car positions)))
           )
      (null?
        (filter
          (lambda (position) (conflict-pos? position row-k k))
          other-positions
          )
        )
      )
    )
  )

(safe? 3 (list (make-board-position 1 3) (make-board-position 3 2) (make-board-position 1 1)))
; expected: false
(safe? 3 (list (make-board-position 5 3) (make-board-position 2 2) (make-board-position 1 1)))
; expected: true


(queens 4)
; with a '(list row column)' representation. Feels a bit weird. Swapping them would be more natural ?
;Value: ((3 4) (1 3) (4 2) (2 1)) ((2 4) (4 3) (1 2) (3 1))
