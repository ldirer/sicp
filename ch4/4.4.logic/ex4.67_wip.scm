(load "ch4/4.4.logic/data_jobs.scm")
; to detect that we entered a loop where we are about to process a query that we are already working on, we could:

; - store a history as a list of (pattern . frame) pairs. The history is a stack: we should remove items once we're done with them.
; - in simple-query, try to lookup the pattern. See the frames associated with it.
; iterate on frame-stream, if a frame matches one of the history frame then raise an error.
; "matches" in this context=variables are 'as free'.
; HMMM I'm not sure how to actually compare frames, because the resolution of variables (that refer to variables, etc) is done in unify-match and pattern-match.
; If we lookup a variable it may appear as bound to ?other-var. That does not tell us if it's free or not.

; Maybe we can use instantiate for that purpose:
; compare frames by comparing the values of (instantiate pattern frame (lambda (var frame) ?free))
; TODO: when do we pop from history?

; TODO ALSO would it be better to test in unify-match (and pattern-match)? If we have a recursive call inside a subpattern. Idk idk.
; TODO shouldn't the history be a stream as well? _feels_ required, otherwise some computation will happen when we don't intend it to.




; reminder of simple-query code:
;(define (simple-query query-pattern frame-stream)
;  (stream-flatmap
;    (lambda (frame)
;      (stream-append-delayed
;        (find-assertions query-pattern frame)
;        (delay (apply-rules query-pattern frame))
;        )
;      )
;    frame-stream
;    )
;  )



(debug-logic)
(outranked-by (Bitdiddle Ben) ?who)
