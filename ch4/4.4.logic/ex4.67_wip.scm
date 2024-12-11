(load "ch4/4.4.logic/data_jobs.scm")
; to detect that we entered a loop where we are about to process a query that we are already working on, we could:

; - store a history as a list of (pattern . frame) pairs. The history is a stack: we should remove items once we're done with them.
; - in simple-query, try to lookup the pattern. See the frames associated with it.
;--> The place to do this is not in simple-query. Pattern matching on assertions cannot create a loop.
; Only rules can create loops.
; When we find a match for a rule conclusion, we want to evaluate the body only if it's not something we have already done before.

; iterate on frame-stream, if a frame matches one of the history frame then raise an error.
; "matches" in this context=variables are 'as free'.
;
; How do we compare frames?
; The resolution of variables (that refer to variables, etc) is done in unify-match and pattern-match...
; If we lookup a variable it may appear as bound to ?other-var. That does not tell us if it's free or not.
; Maybe we can use instantiate for that purpose:
; compare frames by comparing the values of (instantiate pattern frame (lambda (var frame) ?free))


; TODO ALSO would it be better to test in unify-match (and pattern-match)? If we have a recursive call inside a subpattern. Idk idk.
; TODO shouldn't the history be a stream as well? _feels_ required, otherwise some computation will happen when we don't intend it to.



(define (apply-a-rule rule query-pattern query-frame history)
  (let ((clean-rule (rename-variables-in rule)))
    (let ((unify-result
            (unify-match
              query-pattern
              (conclusion clean-rule)
              query-frame
              )
            ))
      (cond
        ((eq? unify-result 'failed) the-empty-stream)
        ((already-processed rule unify-result history)
          (debug-log "LOOP DETECTED, RETURNING EMPTY STREAM FOR: " unify-result)
          the-empty-stream
          )
        (else (qeval (rule-body clean-rule) (singleton-stream unify-result)))
        )
      )
    )
  )


; compare frames by comparing the values of (instantiate pattern frame (lambda (var frame) ?free))
(define (history-instantiate pattern frame) (instantiate pattern frame (lambda (var frame) ?free)))

(define (already-processed rule unified-frame history)
  (lookup-history (history-instantiate (conclusion rule) unified-frame) history)
  )

(define (make-history) '())
(define (extend-history pattern frame history) (cons (history-instantiate pattern frame) history))
(define (first-history history) (car history))
(define (rest-history history) (cdr history))
(define (empty-history history) (null? history))
(define (lookup-history item history)
  (cond
    ((empty-history history) #f)
    ((eq? (first-history history) item) #t)
    (else (lookup item (rest-history history)))
    )
  )

;(define already-processed rule frame history)
