; Louis Reasoner's proposition (without `delay`)
;(define (simple-query query-pattern frame-stream)
;  (stream-flatmap
;    (lambda (frame)
;      (stream-append
;        (find-assertions query-pattern frame)
;        (apply-rules query-pattern frame)))
;    frame-stream)
;  )

; Without the `delay` from the book's version, if the first rule gets stuck in an infinite loop we will not show any results.
; With the delay we at least get the matching assertions before entering the infinite loop.

; ex
(assert! (hop 1))
(assert! (hop 2))
(assert! (hop 3))
(assert! (hop 4))
(assert! (rule (hop ?x) (hop ?x)))

;(hop ?n)
; what we get with the delays (infinite stream):
;(hop 4)
;(hop 3)
;(hop 2)
;(hop 1)
;(hop 4)
;(hop 3)
;(hop 2)
;...
; without the delay we would not see anything, waiting forever for the rule to yield a match.


;(define (disjoin disjuncts frame-stream)
;  (if (empty-disjunction? disjuncts)
;    the-empty-stream
;    (interleave
;      (qeval (first-disjunct disjuncts)
;        frame-stream)
;      (disjoin (rest-disjuncts disjuncts)
;        frame-stream))
;    )
;  )

; Same principle here: without the `delay` from the book's version, the streams will eagerly compute their first element.
; One case when this can be annoying if we would enter an infinite loop doing so.
; with the delay we at least get the first element, before `interleave-delayed` forces the computation triggering the infinite loop.
; Honestly that doesn't feel like a very solid justification. I guess it does make it a bit easier to understand where the bug comes from...
; -> I think maybe context helps. The interleaving is only useful in the context of an infinite stream anyway.
; I was thinking "at that rate why not remove interleaving entirely, we'd get all the results before hanging in the example below".

(assert! (supervisor (Ben) (Boss1)))
(assert! (supervisor (Ben) (Boss2)))

(assert!
  (rule (outranked-by-wrong ?staff-person ?boss)
    (or
      (supervisor ?staff-person ?boss)
      (and
        (outranked-by-wrong ?middle-manager ?boss)
        (supervisor ?staff-person ?middle-manager)
        )
      )
    )
  )

(outranked-by-wrong (Ben) ?who)
; Tested without the delay: no results, hanging.
; with delay, one result, hanging.
; ;;; Query results:
; (outranked-by-wrong (ben) (boss2))
; [HANGS]
