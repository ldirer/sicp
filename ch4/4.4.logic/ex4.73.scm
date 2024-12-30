;Question: Why does `flatten-stream` use delay explicitly?
;What would be wrong with defining it as follows:

;(define (flatten-stream stream)
;  (if
;    (stream-null? stream)
;    the-empty-stream
;    (interleave
;      (stream-car stream)
;      (flatten-stream (stream-cdr stream))
;      )
;    ))
;


; Without the explicit delay this would force precomputing the 'car' of every stream
; in the stream of streams (`stream` argument is a stream of streams).
; I think this could cause an infinite loop where we'd get stuck (not actually yielding values) if the stream we are trying to flatten is infinite.

; let's reuse the example from the last exercise to test this.

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


; termination condition is that the empty list never has the item.
; it's implicit by the *absence of rule* matching the empty list.
(assert!
  (rule (has-item ?item (?car . ?cdr))
    (or
      (same ?car ?item)
      (has-item ?item ?cdr)
      )
    )
  )

; filter to keep only lists without 2.
; Confirmed by changing the code that **this hangs** if we use the non-delay version of flatten-stream.
(and (random-list ?lst) (not (has-item 2 ?lst)))
; With the delay version, we get expected results:
;;;;Query results:
;(and (random-list ()) (not (has-item 2 ())))
;(and (random-list (1)) (not (has-item 2 (1))))
;(and (random-list (1 1)) (not (has-item 2 (1 1))))
;(and (random-list (3)) (not (has-item 2 (3))))
;(and (random-list (1 1 1)) (not (has-item 2 (1 1 1))))
;(and (random-list (4)) (not (has-item 2 (4))))
;(and (random-list (1 3)) (not (has-item 2 (1 3))))
;(and (random-list (3 1)) (not (has-item 2 (3 1))))
;(and (random-list (1 1 1 1)) (not (has-item 2 (1 1 1 1))))
;(and (random-list (4 1)) (not (has-item 2 (4 1))))
;(and (random-list (1 4)) (not (has-item 2 (1 4))))
;(and (random-list (1 1 3)) (not (has-item 2 (1 1 3))))


