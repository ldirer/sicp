(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")


(define (pairs s t)
  (cons-stream
    ; s0, t0
    (list (stream-car s) (stream-car t))
    (interleave
      ; (s0, t1), (s0, t2), ...
      (stream-map
        (lambda (x) (list (stream-car s) x))
        (stream-cdr t)
        )

      (pairs (stream-cdr s) (stream-cdr t))
      )
    )
  )

(define (interleave s1 s2)
  (if (stream-null? s1)
    s2
    (cons-stream
      (stream-car s1)
      (interleave s2 (stream-cdr s1))
      )
    )
  )

(display-stream (until (pairs integers integers) 40))
;(1 1)
;(1 2)
;(2 2)
;(1 3)
;(2 3)
;(1 4)
;(3 3)
;(1 5)
;(2 4)
;(1 6)
;(3 4)
;(1 7)
;(2 5)
;(1 8)
;(4 4)
;(1 9)
;(2 6)
;(1 10)
;(3 5)
;(1 11)
;(2 7)
;(1 12)
;(4 5)
;(1 13)
;(2 8)
;(1 14)
;(3 6)
;(1 15)
;(2 9)
;(1 16)
;(5 5)
;(1 17)
;(2 10)
;(1 18)
;(3 7)
;(1 19)
;(2 11)
;(1 20)
;(4 6)
;(1 21)


; Can you make any general comments about the order in which the pairs are placed into the stream?
; For example, about how many pairs precede the pair (1, 100)?
; The pair (99, 100)?
; The pair (100,100)?


; We're interleaving the 'first row' (refer to the table in the book or the procedure for the exact 'first row' meaning)
; with the rest of the stream, and doing so recursively.
; This means every other pair will be from the first row.
; That leaves 'every other pair' available for the rest of pairs.
; In the rest of pairs, every other pair will be from the first row (second row of the 'original, complete pairs').
; and so on.
; So there should be about 200 pairs before (1, 100).
; Then (2, X) items show up every 4 pairs.
; Then (3, X) items show up every 8 pairs.
; Then (N, X) items show up every 2**N pairs.

; This isn't 100% accurate because the first gap between (2, 2) and (2, 3) is just 2.
; Between (3, 3) and (3, 4) it's 4.
; Looks like the first gap is 2**(N-1).
; Looks like the first (N, X) item (N, N) shows up at (2**N - 1).

; Before (99, 100) there should be about <number to (99, 99) pair> + 2**(99-1) = 2**99 - 1 + 2**98
; Before (100, 100) 2**100-1
; As a sanity check, there should be 2**98 items between (99,100) and (100,100)
; (there are 8 between (4, 5) and (5, 5))
; We can check that:
; 2**99 - 1 + 2**98 + 2**98 =  2**99 + 2**99 - 1 = 2**100 - 1
; as expected.


