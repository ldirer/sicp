; Deﬁne a procedure unique-pairs that, given
; an integer n, generates the sequence of pairs (i, j) with 1 ≤ j < i ≤ n.

; generate numbers from 1 to n
(define (range n)
  (cond ((<= n 0) (list))
    (else (append (range (- n 1)) (list n)))
    ))

(range 5)
;expected: (1 2 3 4 5)

(define nil '())

(define (enumerate-interval low high)
  (if (> low high)
    nil
    (cons low (enumerate-interval (+ low 1) high))))


(define (flatmap function lst)
  (flatten (map function lst))
  )
(define (flatten lst)
  (if (null? lst)
    lst
    (append (car lst) (flatten (cdr lst)))
    )
  )

;(accumulate
;  append nil (map (lambda (i)
;                    (map (lambda (j) (list i j))
;                      (enumerate-interval 1 (- i 1))))
;               (enumerate-interval 1 n))
;  )
;
;(define (flatmap proc seq)
;(accumulate append nil (map proc seq))
;  )

(flatten (list (list 1 2) (list 3 4)))
; expected: 1 2 3 4


(define (unique-pairs n)
  (flatmap (lambda (i)
             (map (lambda (j) (cons i j)) (range (- i 1))))
    (range n))
  )

;(map operation-that-returns-a-list values)
;(list-1 list-2 list-3)


(unique-pairs 4)
; expected: (2 1) (3 1) (3 2) (4 1) (4 2) (4 3)


;(define (triples-summing-to-rec n s)
;  (define (iter i j result-list)
;    (cond
;      ((= j (+ n 1)) result-list)
;      (let ((k (- s (+ i j))))
;        ;      check unique and positive
;        (if (correct i j k s)
;          (cond
;            ((= i n) (iter 1 (+ j 1) (cons (list i j k) result-list)))
;            (else (iter (+ i 1) j (cons (list i j k) result-list)))
;            )
;          (cond
;            ((= i n) (iter 1 (+ j 1) result-list))
;            (else (iter (+ i 1) j result-list))
;            )
;          )
;        )
;
;      )
;    )
;  (iter 1 1 (list))
;  )
;
;(triples-summing-to-rec 5 5)
;

;Write a procedure to ﬁnd all ordered triples
;of distinct positive integers i, j, and k less than or equal to
;a given integer n that sum to a given integer s.
(define (triples-summing-to n s)
  (filter (lambda (x) (not (null? x)))
    (flatmap (lambda (i)
               (map
                 (lambda (j)
                   (let ((k (- s (+ i j))))
                     (cond
                       ((<= k 0) (list))
                       (else (list i j k))
                       )
                     )
                   )
                 (range (- i 1))
                 )
               )
      (range n)
      )
    )
  )


(triples-summing-to 4 5)
;pretty good (but not there yet): ((2 1 2) (3 1 1) (3 2 0) (4 1 0) (4 2 -1) (4 3 -2))

(triples-summing-to 6 7)


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
  (queen-cols board-size)
  )

;rest-of-queens positions for 4 queens on an 8x8 board: SAFE.
;place the 5th queen
; construct a list:
; (rest-of-queens + (first row, column 5),
;  rest-of-queens + (row 2, column 5),
;  rest-of-queens + (row 3, column 5),
;  rest-of-queens + (row 4, column 5),
;  ..)
; construct rest-of-queens + one position (first row, column 5)


; How should we represent positions?
;(x y) (x=column, y=row)
; (y1 y2 y3)
; ((1 y1) (2 y2) (3 y3) ..)
; ((n-1 y1) (n-2 y2) (n-3 y3) ..)


(define (column position)
  (car position)
  )
(define (row position)
  (cdr position)
  )

(define empty-board (list))
; k: column
; positions: list of pairs (col, row) INCLUDING one item with col=k
(define (safe? k positions)
  ; just checking the newest queen here, assuming the other ones are 'safe together'.
  (let ((latest (car positions)))
    (if
      (not (= (car latest) k))
      (error "wrong assumption! Expected the k-th position")  ; Maud: sucks | Jeff: rocks
      (null? (filter (lambda (pos) (is-position-unsafe latest pos)) (cdr positions)))
      )
    )
  )

(define (is-position-unsafe p1 p2)
  (or (is-same-row p1 p2) (is-diagonal p1 p2))
  )

(define (is-same-row p1 p2)
  (= (row p1) (row p2))
  )
(define (is-diagonal p1 p2)
  ; check first diagonal upper left -> bottom right
  ;  -1 col, -1 row
  ;  +1 col, +1 row
  (or
    (= (- (column p1) (row p1)) (- (column p2) (row p2)))
    (= (+ (column p1) (row p1)) (+ (column p2) (row p2)))
    )
  )

(is-diagonal (cons 3 3) (cons 1 1))
; expected: true
(is-diagonal (cons 3 3) (cons 4 4))
; expected: true
(is-diagonal (cons 3 3) (cons 1 4))
; expected: false

(define (adjoin-position new-row k rest-of-queens)
  (cons (cons k new-row) rest-of-queens)
  )

; is this backtracking?

(define SURELY-CORRECT (queens 8))

(length SURELY-CORRECT)
SURELY-CORRECT