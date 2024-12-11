; a global variable used to toggle extremely-verbose logs.
(define *DEBUG* #f)
; did not use `(debug)` because if there is a crash *before* that line it will enter the Scheme debugger.
; makes it confusing, not what we meant to do.
(define (debug? exp) (tagged-list? exp 'debug-logic))
(define (toggle-debug)
  (set! *DEBUG* (not *DEBUG*))
  (newline)
  (display "debug mode is now ")
  (if *DEBUG*
    (display "on")
    (display "off")
    )
  )


(define (qeval query frame-stream)
  (let ((qproc (get (type query) 'qeval)))
    (if qproc
      (qproc (contents query) frame-stream)
      (simple-query query frame-stream)
      )
    )
  )


(define (simple-query query-pattern frame-stream)


  (define (loop-detector frame)
    (define frames-history (lookup-history query-pattern))

    )


  (define (logger frame)
    (if *DEBUG*
      (begin
        (display "simple-query frame for pattern ")
        (display query-pattern)
        (display " : ")
        (display frame)
        (newline)
        )
      )
    frame
    )

  (stream-flatmap
    (lambda (frame)
      (stream-append-delayed
        (find-assertions query-pattern frame)
        (delay (apply-rules query-pattern frame))
        )
      )
    (stream-map logger frame-stream)
    )
  )


; compound queries

; and
(define (conjoin conjuncts frame-stream)
  (define (helper conjuncts frame-stream index)
    (define (maybe-log frame)
      (if (and (= index 0) *DEBUG*)
        (begin
          (display "valid frame for: ")
          (display (first-conjunct conjuncts))
          (display " instantiated frame=")
          ;          (display frame)
          (display (instantiate (first-conjunct conjuncts) frame
                     (lambda (v f)
                       (contract-question-mark v))))
          (newline)
          )
        )
      frame
      )
    (if (empty-conjunction? conjuncts)
      frame-stream
      (helper
        (rest-conjuncts conjuncts)
        (stream-map maybe-log (qeval (first-conjunct conjuncts) frame-stream))
        (+ index 1)
        )
      )
    )
  (helper conjuncts frame-stream 0)
  )


; or
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



