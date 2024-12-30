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

(define (debug-log . msgs)
  (if *DEBUG*
    (for-each display msgs)
    )
  )


(define (qeval query frame-stream history)
  (let ((qproc (get (type query) 'qeval)))
    (if qproc
      (qproc (contents query) frame-stream history)
      (simple-query query frame-stream history)
      )
    )
  )


(define (simple-query query-pattern frame-stream history)

  (stream-flatmap
    (lambda (frame)
      (stream-append-delayed
        (find-assertions query-pattern frame)
        (delay (apply-rules query-pattern frame history))
        )
      )
    frame-stream
    )
  )


; compound queries

; and
(define (conjoin conjuncts frame-stream history)
  (define (helper conjuncts frame-stream index)
    (define (maybe-log frame)
      (if (= index 0)
        (begin
          (debug-log "valid frame for: ")
          (debug-log (first-conjunct conjuncts))
          (debug-log " instantiated frame=")
          (debug-log (instantiate (first-conjunct conjuncts) frame
                       (lambda (v f)
                         (contract-question-mark v))))
          (debug-log "\n")
          )
        )
      frame
      )
    (if (empty-conjunction? conjuncts)
      frame-stream
      (helper
        (rest-conjuncts conjuncts)
        (stream-map maybe-log (qeval (first-conjunct conjuncts) frame-stream history))
        (+ index 1)
        )
      )
    )
  (helper conjuncts frame-stream 0)
  )


; or
(define (disjoin disjuncts frame-stream history)
  (if (empty-disjunction? disjuncts)
    the-empty-stream
    (interleave-delayed
      (qeval (first-disjunct disjuncts) frame-stream history)
      (delay (disjoin (rest-disjuncts disjuncts) frame-stream history))
      )
    )
  )



(define (negate operands frame-stream history)
  (stream-flatmap
    (lambda (frame)
      (if (stream-null? (qeval (negated-query operands) (singleton-stream frame) history))
        ; no matches for query in the frame, include it. (remember we're evaluating 'not query')
        (singleton-stream frame)
        ; the frame matches the query: filter it out
        the-empty-stream
        )
      )
    frame-stream
    )
  )


(define (lisp-value call frame-stream history)
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

(define (always-true ignore frame-stream history) frame-stream)

(put 'lisp-value 'qeval lisp-value)
(put 'and 'qeval conjoin)
(put 'or 'qeval disjoin)
(put 'not 'qeval negate)
(put 'always-true 'qeval always-true)



