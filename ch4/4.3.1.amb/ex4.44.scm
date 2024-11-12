(define (filter proc items)
  (cond ((null? items) '())
    ((proc (car items)) (cons (car items) (filter proc (cdr items))))
    (else (filter proc (cdr items)))
    )
  )

; [low; high]
(define (an-integer-between low high)
  (require (<= low high))
  (amb low (an-integer-between (+ low 1) high))
  )

; copied some things from exercise 2.42.
; Compared with some implementations I saw online (ex: https://www.inchmeal.io/sicp/ch-4/ex-4.44.html), these functions are a bit verbose/convoluted.
(define (conflict-pos? position row-k col-k)
  (let ((row (get-row position))
         (col (get-col position)))
    (or (= row row-k)
      ; diagonal
      (= (abs (- col-k col)) (abs (- row-k row)))
      )
    )
  )

; is the row defined for column k safe with regard to other positions?
(define (safe? k positions)
  (if (null? positions)
    true
    (let (
           (other-positions (cdr positions))
           (row (get-row (car positions)))
           )
      (null?
        (filter
          (lambda (position) (conflict-pos? position row k))
          other-positions
          )
        )
      )
    )
  )

(define (make-position row col) (cons row col))
(define (get-row pos) (car pos))
(define (get-col pos) (cdr pos))

; eight queens again!
; a position is a pair row col
; a solution is a list of positions
; 'k' queens left to place on the NxN board (with N=8 here).
(define (queens k previous-positions)
  (if (= k 0)
    previous-positions
    (let ((row (an-integer-between 1 8)))
      (let ((new-positions (cons (make-position row k) previous-positions)))
        (require (safe? k new-positions))
        (queens (- k 1) new-positions)
        )
      )
    )
  )

(queens 8 '())
;;;; Amb-Eval input:
;(queens 8 '())
;;;; Starting a new problem
;;;; Amb-Eval value:
;((4 . 1) (2 . 2) (7 . 3) (3 . 4) (6 . 5) (8 . 6) (5 . 7) (1 . 8))
