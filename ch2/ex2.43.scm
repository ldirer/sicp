(load "ch2/ex2.42.scm")
;Louis Reasoner wrote this:
;(flatmap
;  (lambda (new-row)
;    (map (lambda (rest-of-queens)
;           (adjoin-position new-row k rest-of-queens))
;      (queen-cols (- k 1))))
;  (enumerate-interval 1 board-size))

; Better writeup: https://eli.thegreenplace.net/2007/08/22/sicp-sections-223

; Original reference solution:
; Each call makes one recursive call: the function is called N + 1 times.
; Now for Louis' solution:
; at step k the recursive call is made N times.
; The call tree is of depth N with N children for *each node*.
; this means N^N calls.
; asymptotically the ratio is O(N^N) (N^(N-1)).
; this might assume that the recursive calls have a fixed complexity (in terms of operations outside recursive calls).
; Which probably isn't true because checking the safety depends on the number of queens already placed.
; I didn't quite observe a N**(N-1) ratio in actual timings.


; trying to verify this
(define (queens-louis board-size)
  (define (queen-cols k)
    (if (= k 0)
      (list empty-board)
      (filter
        (lambda (positions) (safe? k positions))
        (flatmap
          (lambda (new-row)
            (map (lambda (rest-of-queens)
                   (adjoin-position new-row k rest-of-queens))
              (queen-cols (- k 1))))
          (enumerate-interval 1 board-size))
        )))
  (queen-cols board-size)
  )


;(define timings (list))

(define (print-timing) (
                         begin
                           (newline)
                           (display "function ran in ")
                           (display (- end start))
                           (display "s")
                           (newline)
                         )
  )
(define start (runtime))
(queens-louis 5)
(define end (runtime))
(print-timing)

(define start (runtime))
(queens-louis 6)
(define end (runtime))
(print-timing)


(define start (runtime))
(queens-louis 7)
(define end (runtime))
(print-timing)

; slow !
(define start (runtime))
(queens-louis 8)
(define end (runtime))
(print-timing)

; 5: .02s
; 6: .29s
; 7: 4.4s
; 8: 99.3s

; reference version:
; 5: 0.s
; 6: 0.s
; 7: 1.9999999999999574e-2s
; 8: .10s
(define start (runtime))
(queens 5)
(define end (runtime))
(print-timing)

(define start (runtime))
(queens 6)
(define end (runtime))
(print-timing)


(define start (runtime))
(queens 7)
(define end (runtime))
(print-timing)

(define start (runtime))
(queens 8)
(define end (runtime))
(print-timing)

