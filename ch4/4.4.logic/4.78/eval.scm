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


(define (qeval query frame)
  (let ((qproc (get (type query) 'qeval)))
    (if qproc
      (qproc (contents query) frame)
      (simple-query query frame)
      )
    )
  )


(define (simple-query query-pattern frame)
  (amb
    (find-assertions query-pattern frame)
    (apply-rules query-pattern frame)
    )
  )


; compound queries

; and
(define (conjoin conjuncts frame)
  (if (empty-conjunction? conjuncts)
    frame
    (conjoin
      (rest-conjuncts conjuncts)
      (qeval (first-conjunct conjuncts) frame)
      )
    )
  )


; or
(define (disjoin disjuncts frame)
  (if (empty-disjunction? disjuncts)
    (amb)
    (amb
      (qeval (first-disjunct disjuncts) frame)
      (disjoin (rest-disjuncts disjuncts) frame)
      )
    )
  )



(define (negate operands frame)
  (require-fail (qeval (negated-query operands) frame))
  frame
  )

;; This is broken in an interesting way. See comments. Should be able to run it and see prints.
;(define (negate operands frame)
;  ; Here we want to test that the query returns no value.
;  ; I think this can't be done without a language construct? like if-fail.
;  ; if-fail reminder: (if-fail thing-that-fails if-it-fails). Only 2 arguments, not 3.
;  (define has-results
;    (if-fail
;      (begin
;        (qeval (negated-query operands) frame)
;        (display "NEGATE, HAD RESULTS. MEANS WE WONT RETURN THE FRAME")
;        (newline)
;        ; if we get there then there was at least one result.
;        #t
;        )
;      #f
;      )
;    )
;  (display "has-results=")
;  (display has-results)
;  (display ", (negated-query operands)=")
;  (display (negated-query operands))
;  (newline)
;  (if (not has-results)
;    frame
;    ; we cannot call (amb) inside the if-fail first clause, it would cause the evaluator to try again *inside the clause*.
;    ; this is pretty subtle. Look at the comment on: https://www.inchmeal.io/sicp/ch-4/ex-4.78.html
;    (amb)
;    )
;  )


(define (lisp-value call frame)
  (require
    (execute
      (instantiate call frame (lambda (v f) (error "Unknown pat var -- LIST-VALUE" v)))
      )
    )
  frame
  )


(define (execute exp)
  (apply
    (eval (lisp-value-predicate exp))
    (lisp-value-args exp)
    )
  )

(define (always-true ignore frame) frame)

(put 'lisp-value 'qeval lisp-value)
(put 'and 'qeval conjoin)
(put 'or 'qeval disjoin)
(put 'not 'qeval negate)
(put 'always-true 'qeval always-true)



