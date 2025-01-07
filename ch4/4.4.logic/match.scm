; Pattern matching - code from section 4.4.4.3
(load "ch4/4.4.logic/frames.scm")
(load "ch4/4.4.logic/syntax.scm")

; return a stream of frames extending the one passed as argument
(define (find-assertions pattern frame)
  (stream-flatmap
    (lambda (datum)
      (check-an-assertion datum pattern frame)
      )
    (fetch-assertions pattern frame))
  )

(define (check-an-assertion assertion query-pat query-frame)
  (let ((match-result (pattern-match query-pat assertion query-frame)))
    (if (eq? match-result 'failed)
      the-empty-stream
      (singleton-stream match-result)
      )
    )
  )

; below is an implementation I wrote as I tried to figure things out.
; - The book's version is SO MUCH NICER.
; - Also it's SO MUCH MORE CORRECT. With regards to variable values holding variables.
; data cannot contain variables for this 'simple' pattern matching. Unification is when we allow that.

;; frame: list variable bindings - binding: variable, value
;; dat: assertion from the db.
;; Question is: can we bind all variables in the pattern with things in data? Without contradicting frame bindings
;; -> not sure about all variables
;(define (pattern-match pat dat frame)
;  (cond
;    ((eq? frame 'failed) 'failed)
;    ((and (null? pat) (null? dat)) frame)
;    ((or (null? pat) (null? dat)) 'failed)
;    ((var? (car pat))
;      ; what about "values can contain variables"? Not sure what that means anymore...
;      (let ((var-binding (binding-in-frame (cdr (car pat)) frame)))
;        (cond
;          ((not var-binding) (pattern-match (cdr pat) (cdr dat) (extend (cdr (car pat)) (car dat) frame)))
;          ((eq? (binding-value var-binding) (car dat)) (pattern-match (cdr pat) (cdr dat) frame))
;          (else 'failed)
;          )
;        )
;      )
;    ; inner list, might contain variables too: recursive call, then proceed with the extended frame (or 'failed!).
;    ; note we need to test for that *after* testing for variable since they are pairs too!
;    ((pair? (car pat))
;      (if (pair? (car dat))
;        (pattern-match (cdr pat) (cdr dat) (pattern-match (car pat) (car dat) frame))
;        'failed
;        )
;      )
;    ((constant-symbol? (car pat))
;      (if (eq? (car pat) (car dat))
;        (pattern-match (cdr pat) (cdr dat) frame)
;        'failed
;        )
;      )
;    (else (error "THOUGHT UNREACHABLE OH NO"))
;    )
;  )


; Very elegant.
(define (pattern-match pat dat frame)
  (cond
    ((eq? frame 'failed) 'failed)
    ((equal? pat dat) frame)
    ((var? pat) (extend-if-consistent pat dat frame))
    ((and (pair? pat) (pair? dat))
      (pattern-match (cdr pat) (cdr dat) (pattern-match (car pat) (car dat) frame))
      )
    (else 'failed)
    )
  )


(define (extend-if-consistent var dat frame)
  (let ((binding (binding-in-frame var frame)))
    (if binding
      (pattern-match (binding-value binding) dat frame)
      (extend var dat frame)
      )
    )
  )