(define (qeval query frame-stream)
  (let ((qproc (get (type query) 'qeval)))
    (if qproc
      (qproc (contents query) frame-stream)
      (simple-query query frame-stream)
      )
    )
  )


(define (simple-query query-pattern frame-stream)
  (stream-flatmap
    (lambda (frame)
      (stream-append-delayed
        (find-assertions query-pattern frame)
        (delay (apply-rules query-pattern frame))
        )
      )
    frame-stream
    )
  )


; compound queries

(define (conjoin conjuncts frame-stream)
  (if (empty-conjunction? conjuncts)
    frame-stream
    (conjoin
      (rest-conjuncts conjuncts)
      (qeval (first-conjunct conjuncts) frame-stream)
      )
    )
  )


(define (disjoin disjuncts frame-stream)
  (if (empty-disjunction? disjuncts)
    the-empty-stream
    (interleave-delayed
      (qeval (first-disjunct disjuncts) frame-stream)
      (delay (disjoin (rest-disjuncts disjuncts) frame-stream))
      )
    )
  )



; I think we could write this with stream-filter?
; TODO test it. No reason it wouldn't work imo
(define (negate operands frame-stream)
  (stream-flatmap
    (lambda (frame)
      (if (stream-null? (qeval (negated-query operands) (singleton-stream frame)))
        ; no matches for query in the frame, include it. (remember we're evaluating 'not query')
        (singleton-stream frame)
        ; the frame matches the query: filter it out
        the-empty-stream
        )
      )
    frame-stream
    )
  )


(define (lisp-value call frame-stream)
  (stream-flatmap
    (lambda (frame)
      (if (execute
            (instantiate call frame (lambda (v f) (error "Unknown pat var -- LIST-VALUE" v)))
            )
        (singleton-stream frame)
        the-empty-stream)
      )
    frame-stream
    )
  )


(define (execute exp)
  (apply
    (eval (lisp-value-predicate exp) user-initial-environment)
    (lisp-value-args exp)
    )
  )

(define (always-true ignore frame-stream) frame-stream)

(put 'lisp-value 'qeval lisp-value)
(put 'and 'qeval conjoin)
(put 'or 'qeval disjoin)
(put 'not 'qeval negate)
(put 'always-true 'qeval always-true)



