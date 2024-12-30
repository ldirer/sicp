; disjoin and stream-flatmap interleave streams instead of just appending so they behave better with infinite streams.
; Without interleaving the first infinite stream would 'hide' all the others.
; for rules that generate data in particular I can see this being important.

(assert! (rule (same ?a ?a)))
(assert! (random-list ()))
(assert!
  (rule (random-list (?word-car . ?word-cdr))
    (and (or
           (same ?word-car 1)
           (same ?word-car 2)
           (same ?word-car 3)
           (same ?word-car 4)
           )
      (random-list ?word-cdr)
      )
    )
  )

(random-list ?lst)
; Without interleaving, (tested by changing the two calls to interleave-delayed into stream-append-delayed and running it):
;;;; Query results:
;(random-list ())
;(random-list (1))
;(random-list (1 1))
;(random-list (1 1 1))
;(random-list (1 1 1 1))
;(random-list (1 1 1 1 1))
;(random-list (1 1 1 1 1 1))

; With interleaving, we get more interesting data:
;;;; Query results:
;(random-list ())
;(random-list (1))
;(random-list (2))
;(random-list (1 1))
;(random-list (3))
;(random-list (1 2))
;(random-list (2 1))
;(random-list (1 1 1))
;(random-list (4))
;(random-list (1 3))
;(random-list (2 2))
;(random-list (1 1 2))
;(random-list (3 1))
;(random-list (1 2 1))
;(random-list (2 1 1))
;(random-list (1 1 1 1))
;(random-list (4 1))

; Note that this is not perfect! The 'random list' elements are heavily skewed towards the first option in the 'or' statement.



;example from https://www.inchmeal.io/sicp/ch-4/ex-4.72.html
;(assert! (ones ()))
;(assert! (rule (ones (1 . ?x)) (ones ?x)))
;
;(assert! (twos ()))
;(assert! (rule (twos (2 . ?x)) (twos ?x)))
;(or (ones ?x) (twos ?x))
